import '../../data/models/transport_option.dart';

class RecommendationEngine {

  static TransportOption getBestOption(

    List<TransportOption> options,
    String preference,
    String weather,
    String traffic,

  ) {

    List<TransportOption> sorted =
        List.from(options);

    // WEATHER IMPACT

    if (weather == 'Rainy' ||
        weather == 'Stormy') {

      sorted.removeWhere(
        (option) =>
            option.vehicle == 'Bike',
      );
    }

    // TRAFFIC IMPACT

    if (traffic == 'High') {

      sorted.sort(
        (a, b) =>
            a.time.compareTo(b.time),
      );
    }

    // USER PREFERENCE

    switch (preference) {

      case 'Cheapest':

        sorted.sort(
          (a, b) =>
              a.price.compareTo(b.price),
        );

        break;

      case 'Fastest':

        sorted.sort(
          (a, b) =>
              a.time.compareTo(b.time),
        );

        break;

      case 'Comfort':

        sorted.sort(
          (a, b) =>
              b.comfort.compareTo(a.comfort),
        );

        break;
    }

    return sorted.first;
  }
}