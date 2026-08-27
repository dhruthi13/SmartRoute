import 'dart:math';

class WeatherTrafficEngine {
  static final Random random = Random();

  static const List<String> weatherList = [
    'Sunny',
    'Rainy',
    'Cloudy',
    'Stormy',
  ];

  static const List<String> trafficList = [
    'Low',
    'Medium',
    'High',
  ];

  static String getWeather() {
    return weatherList[random.nextInt(weatherList.length)];
  }

  static String getTraffic() {
    return trafficList[random.nextInt(trafficList.length)];
  }

  static String getTrafficEmoji(String traffic) {
    switch (traffic) {
      case 'Low':
        return 'Low';
      case 'Medium':
        return 'Med';
      case 'High':
        return 'High';
      default:
        return '--';
    }
  }

  static String getWeatherAdvice(String weather) {
    switch (weather) {
      case 'Sunny':
        return 'Great weather for travel. Bike and Metro are recommended.';
      case 'Rainy':
        return 'Rain detected. Avoid Bike. Cab or Metro recommended.';
      case 'Cloudy':
        return 'Weather is pleasant for all transport options.';
      case 'Stormy':
        return 'Heavy weather alert. Prefer safer transport like Metro or Cab.';
      default:
        return 'Travel safely.';
    }
  }
}
