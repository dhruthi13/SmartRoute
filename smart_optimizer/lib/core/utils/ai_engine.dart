import '../../data/models/transport_option.dart';

class AIEngine {

  static TransportOption recommend(

    List<TransportOption> options,
    String preference,
    String weather,
    String traffic,

  ) {

    List<TransportOption> filtered =
        List.from(options);

    // Rain Logic

    if (weather == 'Rainy' ||
        weather == 'Stormy') {

      filtered.removeWhere(
        (e) => e.vehicle == 'Bike',
      );
    }

    // Traffic Logic

    if (traffic == 'High') {

      filtered.sort(
        (a, b) =>
            a.time.compareTo(b.time),
      );
    }

    // User Preference

    switch (preference) {

      case 'Cheapest':

        filtered.sort(
          (a, b) =>
              a.price.compareTo(b.price),
        );

        break;

      case 'Fastest':

        filtered.sort(
          (a, b) =>
              a.time.compareTo(b.time),
        );

        break;

      case 'Comfort':

        filtered.sort(
          (a, b) =>
              b.comfort.compareTo(a.comfort),
        );

        break;
    }

    return filtered.first;
  }
}