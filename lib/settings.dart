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
    0: FaderGroupConfig(name: 'default', faders: [
      StereoFader(
        name: 'Fader 1',
        leftChannelid: '0',
        rightChannelid: '1',
      ),
      StereoFader(
        name: 'Fader 2',
        leftChannelid: '2',
        rightChannelid: '3',
      ),
      StereoFader(
        name: 'Fader 3',
        leftChannelid: '4',
        rightChannelid: '5',
      )
    ]),
    1: FaderGroupConfig(name: 'default 2', faders: [
      StereoFader(
        name: 'Fader 4',
        leftChannelid: '6',
        rightChannelid: '7',
      ),
      StereoFader(
        name: 'Fader 5',
        leftChannelid: '8',
        rightChannelid: '9',
      ),
      StereoFader(
        name: 'Fader 6',
        leftChannelid: '10',
        rightChannelid: '11',
      )
    ]),
    2: FaderGroupConfig(name: 'default 3', faders: [
      StereoFader(
        name: 'Fader 7',
        leftChannelid: '12',
        rightChannelid: '13',
      ),
      StereoFader(
        name: 'Fader 8',
        leftChannelid: '14',
        rightChannelid: '15',
      ),
      StereoFader(
        name: 'Fader 9',
        leftChannelid: '16',
        rightChannelid: '17',
      )
    ]),
  };
}