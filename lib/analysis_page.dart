import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Code Sample'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: LineChart(
          LineChartData(lineBarsData: [
            LineChartBarData(spots: const [
              FlSpot(1, 323),
              FlSpot(2, 538),
              FlSpot(3, 368),
              FlSpot(4, 259),
              FlSpot(5, 551),
              FlSpot(6, 226),
              FlSpot(7, 268),
              FlSpot(8, 296),
              FlSpot(9, 203),
              FlSpot(10, 246),
              FlSpot(11, 345),
            ])
          ]),
        ),
      ),
    );
  }
}
