import 'package:flutter/material.dart';
import 'package:taimane_timemanager/analysis_page.dart';
// import 'package:taimane_timemanager/analysis_page.dart';
import 'package:taimane_timemanager/timer_list.dart';

class ScreensPage extends StatefulWidget {
  @override
  _ScreensPageState createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TimerList(),
    const MyChart(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: '分析',
          ),
        ],
      ),
    );
  }
}
