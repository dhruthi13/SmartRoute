import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/models/route_model.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;

  const RouteCard({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            route.transport,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              info('Time', '${route.duration} min'),
              info('Cost', '₹${route.cost}'),
              info('Comfort', route.comfort),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: route.score,
            minHeight: 10,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.grey.shade800,
          ),
          const SizedBox(height: 8),
          Text(
            'Smart Score: ${(route.score * 100).toInt()}%',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget info(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}