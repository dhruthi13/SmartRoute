import 'package:dio/dio.dart';

class LocationService {

  final Dio dio = Dio();

  Future<List<double>?> getCoordinates(
      String place) async {

    final response = await dio.get(
      'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'q': place,
        'format': 'json',
        'limit': 1,
      },
    );

    if (response.data.isEmpty) {
      return null;
    }

    final data = response.data[0];

    return [
      double.parse(data['lon']),
      double.parse(data['lat']),
    ];
  }
}