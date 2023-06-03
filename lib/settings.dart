import 'models.dart';

FaderGroupConfig getFaderGroupConfigMainPage(int groupId) {
  var groups = {
    0: FaderGroupConfig(name: 'default', faders: [
      StereoFader(
        name: 'Fader 1',
        leftChannelid: '1',
        rightChannelid: '2',
      ),
      StereoFader(
        name: 'Fader 2',
        leftChannelid: '3',
        rightChannelid: '4',
      ),
      StereoFader(
        name: 'Fader 3',
        leftChannelid: '5',
        rightChannelid: '6',
      )
    ]),
    1: FaderGroupConfig(name: 'default 2', faders: [
      StereoFader(
        name: 'Fader 4',
        leftChannelid: '7',
        rightChannelid: '8',
      ),
      StereoFader(
        name: 'Fader 5',
        leftChannelid: '9',
        rightChannelid: '10',
      ),
      StereoFader(
        name: 'Fader 6',
        leftChannelid: '11',
        rightChannelid: '12',
      )
    ]),
    2: FaderGroupConfig(name: 'default 3', faders: [
      StereoFader(
        name: 'Fader 7',
        leftChannelid: '13',
        rightChannelid: '14',
      ),
      StereoFader(
        name: 'Fader 8',
        leftChannelid: '15',
        rightChannelid: '16',
      ),
      StereoFader(
        name: 'Fader 9',
        leftChannelid: '17',
        rightChannelid: '18',
      )
    ]),
  };

  var resultGroup = groups[groupId];
  resultGroup ??= FaderGroupConfig(name: 'unknown group', faders: [
      StereoFader(
        name: 'Unknown Fader 1',
        leftChannelid: '1',
        rightChannelid: '2',
      ),
      StereoFader(
        name: 'Unknown Fader 2',
        leftChannelid: '3',
        rightChannelid: '4',
      ),
      StereoFader(
        name: 'Unknown Fader 3',
        leftChannelid: '5',
        rightChannelid: '6',
      )
    ]);

  return resultGroup;
}
