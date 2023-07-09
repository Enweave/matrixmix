import 'package:matrixmix/settings.dart';
import 'package:http/http.dart' as http;

class DSPServerService {
  Future<bool> hello (defaultHost) async {
    var url = ApiInfo().getHelloUrl(host:defaultHost);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}