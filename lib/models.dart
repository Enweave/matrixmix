import 'package:flutter/material.dart';
import 'package:matrixmix/settings.dart';

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

  StereoFader(
      {this.name = '<none>',
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
  String hostName = '';
  bool isConnected = false;
  int currentSubmix = 1;
  Map<String, int> faders = {};

  DSPServerModel({this.hostName = ApiInfo.defaultHost}) {
    hostName = hostName;
  }

  void updateConnectionStatus(bool status) {
    isConnected = status;
    notifyListeners();
  }

  void updateCurrentSubmix(int submix) {
    currentSubmix = submix;
    notifyListeners();
  }

  void update() {}
}