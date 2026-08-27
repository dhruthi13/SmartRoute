import 'package:dio/dio.dart';

class RouteService {
  final Dio dio = Dio();

  final String apiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjI3YzI0ZmUwOGRlZTRlOGRiNzQxNWIwOWMzNDQ1NzJjIiwiaCI6Im11cm11cjY0In0=';

  Future<Map<String, dynamic>> getRoute({
    required List<double> start,
    required List<double> end,
  }) async {
    final response = await dio.get(
      'https://api.openrouteservice.org/v2/directions/driving-car',
      queryParameters: {
        'api_key': apiKey,
        'start': '${start[0]},${start[1]}',
        'end': '${end[0]},${end[1]}',
      },
    );

    return response.data;
  }
}