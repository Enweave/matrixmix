import 'package:matrixmix/settings.dart';
import 'package:http/http.dart' as http;

class DSPServerService {
  Future<bool> hello () async {
    final response = await http.get(ApiInfo().getHelloUrl());
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}