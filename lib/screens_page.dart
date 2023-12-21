import 'package:flutter/material.dart';
import 'package:taimane_timemanager/analysis_page.dart';
import 'package:taimane_timemanager/timer_list.dart';

class ScreensPage extends StatefulWidget {
  @override
  _ScreensPageState createState() => _ScreensPageState();
}

class _ScreensPageState extends State<ScreensPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // 各画面を追加してください
    const TimerList(),
    const AnalysisPage(),
    // 他の画面...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
          // 他のアイテム...
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('ホーム画面'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('設定画面'),
      ),
    );
  }
}
