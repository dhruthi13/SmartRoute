import '../../data/models/transport_option.dart';

class TransportCalculator {

  static List<TransportOption>
      generateOptions(double distanceKm) {

    return [

      TransportOption(
        vehicle: 'Bike',
        price: distanceKm * 8,
        time: (distanceKm * 3).toInt(),
        comfort: 'Medium',
      ),

      TransportOption(
        vehicle: 'Auto',
        price: distanceKm * 15,
        time: (distanceKm * 2.5).toInt(),
        comfort: 'Medium',
      ),

      TransportOption(
        vehicle: 'Cab',
        price: distanceKm * 22,
        time: (distanceKm * 2).toInt(),
        comfort: 'High',
      ),

      TransportOption(
        vehicle: 'Bus',
        price: distanceKm * 3,
        time: (distanceKm * 4).toInt(),
        comfort: 'Low',
      ),

      TransportOption(
        vehicle: 'Metro',
        price: distanceKm * 5,
        time: (distanceKm * 2.2).toInt(),
        comfort: 'High',
      ),
    ];
  }
}