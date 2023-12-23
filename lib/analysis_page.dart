import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyChart extends StatelessWidget {
  const MyChart({Key? key}) : super(key: key);

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
              FlSpot(1, 10),
              FlSpot(2, 20),
              FlSpot(3, 30),
              FlSpot(4, 40),
              FlSpot(5, 50),
              FlSpot(6, 60),
              FlSpot(7, 70),
              FlSpot(8, 80),
              FlSpot(9, 90),
              FlSpot(10, 100),
              FlSpot(0, 0),
            ])
          ]),
        ),
      ),
    );
  }
}
