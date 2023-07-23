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
        leftChannelid: '1',
        rightChannelid: '6',
      ),
      StereoFader(
        name: 'Fader 2',
        leftChannelid: '3',
        rightChannelid: '8',
      ),
      StereoFader(
        name: 'Fader 3',
        leftChannelid: '5',
        rightChannelid: '10',
      )
    ]),
    1: FaderGroupConfig(name: '2', faders: [
      StereoFader(
        name: 'Fader 4',
        leftChannelid: '31',
        rightChannelid: '24',
      ),
      StereoFader(
        name: 'Fader 5',
        leftChannelid: '33',
        rightChannelid: '26',
      ),
      StereoFader(
        name: 'Fader 6',
        leftChannelid: '35',
        rightChannelid: '28',
      )
    ]),
    2: FaderGroupConfig(name: '3', faders: [
      StereoFader(
        name: 'Fader 7',
        leftChannelid: '13',
        rightChannelid: '18',
      ),
      StereoFader(
        name: 'Fader 8', //ok
        leftChannelid: '15',
        rightChannelid: '20',
      ),
      StereoFader(
        name: 'Fader 9',
        leftChannelid: '17',
        rightChannelid: '22',
      )
    ]),
  };
}