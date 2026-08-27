import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {

  static Future<void> saveRoute(

    String source,
    String destination,

  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    List<String> routes =
        prefs.getStringList('routes') ?? [];

    routes.add('$source → $destination');

    await prefs.setStringList(
      'routes',
      routes,
    );
  }

  static Future<List<String>>
      getRoutes() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getStringList('routes') ?? [];
  }
}