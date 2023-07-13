import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matrixmix/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class FaderBase {
  bool isBipolar;
  int value = 0;
  int minValue = 0;
  int maxValue = 255;

  FaderBase({this.isBipolar = false}) {
    isBipolar = isBipolar;
    if (isBipolar == true) {
      minValue = -127;
      maxValue = 127;
    }
  }
}

class StereoFader {
  String name;
  String leftChannelid;
  String rightChannelid;
  FaderBase volumeFader = FaderBase();
  FaderBase panFader = FaderBase(isBipolar: true);

  final int deviceMinValue = 0;
  final int deviceMaxValue = 255;

  StereoFader({
    this.name = '<none>',
    this.leftChannelid = '<none>',
    this.rightChannelid = '<none>',
  }) {
    name = name;
    leftChannelid = leftChannelid;
    rightChannelid = rightChannelid;
  }

  void valuesFromJson(Map<String, dynamic> json) {
    var leftVolume = json[leftChannelid];
    var rightVolume = json[rightChannelid];
    volumeFader.value = (leftVolume + rightVolume) ~/ 2;
    panFader.value = (leftVolume - rightVolume) ~/ 2;

    volumeFader.value.clamp(volumeFader.minValue, volumeFader.maxValue);
    panFader.value.clamp(panFader.minValue, panFader.maxValue);
  }

  Map<String, dynamic> valuesToJson() {
    var leftVolume = volumeFader.value + panFader.value;
    var rightVolume = volumeFader.value - panFader.value;
    return {
      leftChannelid: leftVolume.clamp(deviceMinValue, deviceMaxValue),
      rightChannelid: rightVolume.clamp(deviceMinValue, deviceMaxValue)
    };
  }
}

class FaderGroupConfig {
  String name;
  String? userName;
  List<StereoFader> faders;

  FaderGroupConfig({this.name = '<none>', required this.faders}) {
    name = name;
    faders = faders;
  }
}

class DSPServerModel extends ChangeNotifier {
  SharedPreferences prefs;
  WebSocketChannel? channel = null;
  String schemeHttp = 'http://';
  String schemeWs = 'ws://';
  int httpPort = 80;
  int wsPort = 80;
  String hostName = '192.168.1.53';
  bool isConnected = false;
  int currentSubmix = 0;
  Map<int, FaderGroupConfig> faderGroups = {};

  void _updateConnectionStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  Uri getHelloUrl() {
    // TODO: implement version check
    return Uri.parse('$schemeHttp$hostName:$httpPort/hello');
  }

  Uri getFadersUrl() {
    return Uri.parse('$schemeHttp$hostName:$httpPort/faders');
  }

  Uri getWsUrl() {
    return Uri.parse('$schemeWs$hostName:$wsPort/ws');
  }

  Future<bool> fetchFadersData() async {
    bool result = false;
    final response = await http.get(getFadersUrl());
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['faders'] != null) {
        debugPrint('json $json');
        updateFaderValues(json['faders']);
        result = true;
      }
    }
    return result;
  }

  Future connect() async {
    bool fetch_success = await fetchFadersData();
    if (fetch_success) {
      if (channel != null) {
        channel!.sink.close();
      }
      channel = WebSocketChannel.connect(getWsUrl());
      try {
        await channel?.ready;
        _updateConnectionStatus(true);
        channel?.stream.listen(
          (dynamic message) {
            debugPrint('message $message');
            var json = jsonDecode(message);
            if (json['faders'] != null) {
              debugPrint('json $json');
              updateFaderValues(json['faders']);
            }
          },
          onDone: () {
            _updateConnectionStatus(false);
            debugPrint('ws channel closed');
          },
          onError: (error) {
            _updateConnectionStatus(false);
            debugPrint('ws error $error');
          },
        );
      } catch (e) {
        // log error
        debugPrint('ws error $e');
        _updateConnectionStatus(false);
      }
    } else {
      _updateConnectionStatus(false);
    }
  }

  DSPServerModel(this.prefs) {
    hostName = prefs.getString(HOSTNAME_SETTINGS_KEY) ?? hostName;
    currentSubmix = prefs.getInt(SUBMIX_SETTINGS_KEY) ?? currentSubmix;
    httpPort = prefs.getInt(HTTP_PORT_SETTINGS_KEY) ?? httpPort;
    wsPort = prefs.getInt(WS_PORT_SETTINGS_KEY) ?? wsPort;
    faderGroups = getFaderGroupConfigs();
  }

  void updateHostName(String host) {
    hostName = host;
    prefs.setString(HOSTNAME_SETTINGS_KEY, host);
    notifyListeners();
  }

  void updateHttpPort(int port) {
    httpPort = port;
    prefs.setInt(HTTP_PORT_SETTINGS_KEY, port);
    notifyListeners();
  }

  void updateWsPort(int port) {
    wsPort = port;
    prefs.setInt(WS_PORT_SETTINGS_KEY, port);
    notifyListeners();
  }

  void updateCurrentSubmix(int submix) {
    currentSubmix = submix;
    prefs.setInt(SUBMIX_SETTINGS_KEY, submix);
    notifyListeners();
  }

  void sendFaderValues() {
    Map<String, dynamic> data = {};
    Map<String, dynamic> faders = {};
    if (isConnected) {
      faderGroups.forEach((key, group) {
        group.faders.forEach((fader) {
          faders.addAll(fader.valuesToJson());
        });
      });
      data['faders'] = faders;
      channel?.sink.add(jsonEncode(data));
    }
  }

  void updateFaderValues(Map<String, dynamic> json) {
    faderGroups.forEach((key, group) {
      group.faders.forEach((fader) {
        fader.valuesFromJson(json);
      });
    });
    notifyListeners();
  }

  void update() {}
}
