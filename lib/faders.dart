class FadersData {
  // map of faders
  late Map<String, int> faders;

  // constructor
  FadersData() {
    faders = {};
  }

  factory FadersData.fromJson(Map<String, dynamic> json) {
    FadersData fadersData = FadersData();
    var fader_data = json['faders'];
    fader_data.forEach((key, value) {
      // check that value is between 0 and 255
      if (value < 0) {
        value = 0;
      } else if (value > 255) {
        value = 255;
      }
      fadersData.faders[key] = value;
    });
    return fadersData;
  }
}