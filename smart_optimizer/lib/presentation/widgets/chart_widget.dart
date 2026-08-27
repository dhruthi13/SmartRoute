import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/transport_option.dart';

class ChartWidget extends StatelessWidget {

  final List<TransportOption> options;

  const ChartWidget({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 300,

      child: BarChart(

        BarChartData(

          barGroups:

              options.asMap().entries.map(

            (entry) {

              int index = entry.key;

              TransportOption option =
                  entry.value;

              return BarChartGroupData(

                x: index,

                barRods: [

                  BarChartRodData(
                    toY: option.price,
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}