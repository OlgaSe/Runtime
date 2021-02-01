import 'package:http/http.dart' as http;
import 'dart:convert';

//helper class when we initialize this class, we pass url and send url request
class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    http.Response response = await http.get(url);

    // 'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&appid=$apiKey'
    // print(response.body);
    // print(response.statusCode);

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      return jsonDecode(data);//using jsonDecode to decode the response data
    } else {
      print(response.statusCode);
    }
  }
}
