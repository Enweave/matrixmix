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
  String hostName = '';
  bool isConnected = false;
  int currentSubmix = 0;
  Map<int, FaderGroupConfig> faderGroups = {};

  void _updateConnectionStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  Future connect() async {
    final response = await http.get(ApiInfo().getHelloUrl(host: hostName));
    if (response.statusCode == 200) {
      receiveFaderValues(jsonDecode(response.body));
    }

    if (channel != null) {
      channel!.sink.close();
    }

    Uri url = ApiInfo().getWsUrl(host: hostName);
    channel = WebSocketChannel.connect(url);
    try {
      await channel?.ready;
      _updateConnectionStatus(true);
      channel?.stream.listen(
        (dynamic message) {
          debugPrint('message $message');
          receiveFaderValues(jsonDecode(message));
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
  }

  DSPServerModel(this.prefs) {
    hostName = prefs.getString(HOSTNAME_SETTINGS_KEY) ?? ApiInfo.defaultHost;
    currentSubmix = prefs.getInt(SUBMIX_SETTINGS_KEY) ?? currentSubmix;
    faderGroups = getFaderGroupConfigs();
  }

  void updateHostName(String host) {
    hostName = host;
    prefs.setString(HOSTNAME_SETTINGS_KEY, host);
    notifyListeners();
  }

  void updateCurrentSubmix(int submix) {
    currentSubmix = submix;
    prefs.setInt(SUBMIX_SETTINGS_KEY, submix);
    notifyListeners();
  }

  void sendFaderValues() {
    Map<String, dynamic> data = {};
    if (isConnected) {
      faderGroups.forEach((key, group) {
        group.faders.forEach((fader) {
          data.addAll(fader.valuesToJson());
        });
      });
      channel?.sink.add(jsonEncode(data));
    }
  }

  void receiveFaderValues(Map<String, dynamic> json) {
    faderGroups.forEach((key, group) {
      group.faders.forEach((fader) {
        fader.valuesFromJson(json);
      });
    });
    notifyListeners();
  }

  void update() {}
}
