import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  static const apiKey =
      'e4049f9c7b692a673a60722ff805ad67';

  static Future<String> getWeather(
    double lat,
    double lon,
  ) async {

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    final response =
        await http.get(
      Uri.parse(url),
    );

    final data =
        jsonDecode(response.body);

    return data['weather'][0]['main'];
  }
}