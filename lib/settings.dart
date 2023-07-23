import 'models.dart';

const String HOME_PAGE = 'home';
const String SETTINGS_PAGE = 'settings';
const String HOSTNAME_SETTINGS_KEY = 'hostname';
const String SUBMIX_SETTINGS_KEY = 'submix';
const String HTTP_PORT_SETTINGS_KEY = 'httpPort';
const String WS_PORT_SETTINGS_KEY = 'wsPort';
const Duration FADER_SEND_INTERVAL = Duration(milliseconds: 50);

Map<int, FaderGroupConfig> getFaderGroupConfigs() {
  return {
    0: FaderGroupConfig(name: '1', faders: [
      StereoFader(
        name: 'Fader 1',
        leftChannelid: '0',
        rightChannelid: '7',
      ),
      StereoFader(
        name: 'Fader 2',
        leftChannelid: '2',
        rightChannelid: '9',
      ),
      StereoFader(
        name: 'Fader 3',
        leftChannelid: '4',
        rightChannelid: '11',
      )
    ]),
    1: FaderGroupConfig(name: '2', faders: [
      StereoFader(
        name: 'Fader 4',
        leftChannelid: '30',
        rightChannelid: '25',
      ),
      StereoFader(
        name: 'Fader 5',
        leftChannelid: '32',
        rightChannelid: '27',
      ),
      StereoFader(
        name: 'Fader 6',
        leftChannelid: '34',
        rightChannelid: '29',
      )
    ]),
    2: FaderGroupConfig(name: '3', faders: [
      StereoFader(
        name: 'Fader 7',
        leftChannelid: '12',
        rightChannelid: '19',
      ),
      StereoFader(
        name: 'Fader 8',
        leftChannelid: '14',
        rightChannelid: '21',
      ),
      StereoFader(
        name: 'Fader 9',
        leftChannelid: '16',
        rightChannelid: '23',
      )
    ]),
  };
}