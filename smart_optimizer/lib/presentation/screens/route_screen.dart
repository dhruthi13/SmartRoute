import 'package:flutter/material.dart';

import '../../core/utils/favorites_manager.dart';
import '../../core/utils/recommendation_engine.dart';
import '../../core/utils/transport_calculator.dart';
import '../../core/utils/weather_traffic_engine.dart';
import '../../data/models/transport_option.dart';
import '../../data/services/location_service.dart';
import '../../data/services/route_service.dart';
import '../../data/services/weather_service.dart';
import 'map_screen.dart';

class RouteScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String preference;
  final List<String> stops;

  const RouteScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.preference,
    required this.stops,
  });

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final RouteService routeService = RouteService();
  final LocationService locationService = LocationService();

  String distance = '';
  String duration = '';
  String weather = '';
  String traffic = '';

  bool isLoading = true;
  double startLat = 0;
  double startLng = 0;
  double endLat = 0;
  double endLng = 0;

  List<TransportOption> options = [];
  TransportOption? bestOption;

  @override
  void initState() {
    super.initState();
    loadRoute();
  }

  Future<void> loadRoute() async {
    try {
      final startCoordinates = await locationService.getCoordinates(
        widget.source,
      );
      final endCoordinates = await locationService.getCoordinates(
        widget.destination,
      );

      if (startCoordinates == null || endCoordinates == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid location entered'),
          ),
        );
        Navigator.pop(context);
        return;
      }

      final routeData = await routeService.getRoute(
        start: startCoordinates,
        end: endCoordinates,
      );

      final features = routeData['features'];
      if (features is! List || features.isEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Route not found'),
          ),
        );
        return;
      }

      final firstFeature = features.first;
      final properties = firstFeature is Map<String, dynamic>
          ? firstFeature['properties']
          : null;
      final summary =
          properties is Map<String, dynamic> ? properties['summary'] : null;

      if (summary is! Map<String, dynamic>) {
        throw const FormatException('Route summary missing');
      }

      final distanceMeters = (summary['distance'] as num?)?.toDouble() ?? 0;
      final durationSeconds = (summary['duration'] as num?)?.toDouble() ?? 0;
      final distanceKm = distanceMeters / 1000;
      final generatedOptions = TransportCalculator.generateOptions(distanceKm);

      final liveWeather = await WeatherService.getWeather(
        startCoordinates[1],
        startCoordinates[0],
      );
      final liveTraffic = WeatherTrafficEngine.getTraffic();
      final recommended = generatedOptions.isNotEmpty
          ? RecommendationEngine.getBestOption(
              generatedOptions,
              widget.preference,
              liveWeather,
              liveTraffic,
            )
          : null;

      if (!mounted) {
        return;
      }

      setState(() {
        startLat = startCoordinates[1];
        startLng = startCoordinates[0];
        endLat = endCoordinates[1];
        endLng = endCoordinates[0];
        distance = distanceKm.toStringAsFixed(2);
        duration = (durationSeconds / 60).toStringAsFixed(0);
        options = generatedOptions;
        weather = liveWeather;
        traffic = liveTraffic;
        bestOption = recommended;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  String getRecommendationReason() {
    switch (widget.preference) {
      case 'Cheapest':
        return 'Recommended because it has the lowest fare.';
      case 'Fastest':
        return 'Recommended because it saves maximum travel time.';
      case 'Comfort':
        return 'Recommended because it provides better comfort.';
      default:
        return 'Recommended because it offers the best balance.';
    }
  }

  IconData getVehicleIcon(String vehicle) {
    switch (vehicle) {
      case 'Bike':
        return Icons.two_wheeler;
      case 'Auto':
        return Icons.electric_rickshaw;
      case 'Cab':
        return Icons.local_taxi;
      case 'Bus':
        return Icons.directions_bus;
      case 'Metro':
        return Icons.train;
      default:
        return Icons.directions;
    }
  }

  Future<void> saveRoute() async {
    await FavoritesManager.saveRoute(
      widget.source,
      widget.destination,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Route saved'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Route'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RouteHeader(
                    source: widget.source,
                    destination: widget.destination,
                  ),
                  const SizedBox(height: 40),
                  _TripSummaryCard(
                    distance: distance,
                    duration: duration,
                  ),
                  const SizedBox(height: 20),
                  _LiveConditionsCard(
                    weather: weather,
                    traffic: traffic,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Recommended Transport',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (bestOption != null)
                    _RecommendedTransportCard(
                      option: bestOption!,
                      icon: getVehicleIcon(bestOption!.vehicle),
                      reason: getRecommendationReason(),
                    )
                  else
                    const Text('No transport options available.'),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text(
                        'Open Route Map',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapScreen(
                              startLat: startLat,
                              startLng: startLng,
                              endLat: endLat,
                              endLng: endLng,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: saveRoute,
                    icon: const Icon(Icons.star),
                    label: const Text('Save Route'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'All Transport Options',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final option in options)
                    _TransportOptionCard(
                      option: option,
                      isBest: option.vehicle == bestOption?.vehicle,
                      icon: getVehicleIcon(option.vehicle),
                    ),
                ],
              ),
            ),
    );
  }
}

class _RouteHeader extends StatelessWidget {
  final String source;
  final String destination;

  const _RouteHeader({
    required this.source,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            source,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Icon(
            Icons.arrow_downward,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            destination,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TripSummaryCard extends StatelessWidget {
  final String distance;
  final String duration;

  const _TripSummaryCard({
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Distance: $distance km',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Base Duration: $duration mins',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveConditionsCard extends StatelessWidget {
  final String weather;
  final String traffic;

  const _LiveConditionsCard({
    required this.weather,
    required this.traffic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Conditions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.cloud,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Weather: $weather',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                WeatherTrafficEngine.getTrafficEmoji(traffic),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Traffic: $traffic',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              WeatherTrafficEngine.getWeatherAdvice(weather),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTransportCard extends StatelessWidget {
  final TransportOption option;
  final IconData icon;
  final String reason;

  const _RecommendedTransportCard({
    required this.option,
    required this.icon,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.deepPurpleAccent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 42,
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  option.vehicle,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const _BestBadge(),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricColumn(
                label: 'Fare',
                value: 'Rs. ${option.price.toStringAsFixed(0)}',
              ),
              _MetricColumn(
                label: 'Time',
                value: '${option.time} mins',
              ),
              _MetricColumn(
                label: 'Comfort',
                value: option.comfort,
                valueSize: 22,
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              reason,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransportOptionCard extends StatelessWidget {
  final TransportOption option;
  final bool isBest;
  final IconData icon;

  const _TransportOptionCard({
    required this.option,
    required this.isBest,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isBest ? Colors.deepPurple.withValues(alpha: 0.20) : Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBest ? Colors.deepPurpleAccent : Colors.white12,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 35,
                color: isBest ? Colors.deepPurpleAccent : Colors.white,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  option.vehicle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isBest) const _BestBadge(),
            ],
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 22,
            runSpacing: 12,
            children: [
              Text(
                'Rs. ${option.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${option.time} mins',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                option.comfort,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Safety Score: ${80 + option.time % 20}%',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final double valueSize;

  const _MetricColumn({
    required this.label,
    required this.value,
    this.valueSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _BestBadge extends StatelessWidget {
  const _BestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'BEST',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
