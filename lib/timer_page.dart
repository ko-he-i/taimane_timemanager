import 'package:flutter/material.dart';
import 'dart:async';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.docId});
  final String docId;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _seconds = 0;
  int _minutes = 0;
  int _hour = 0;
  String _secondsString = '00';
  String _minutesString = '00';
  String _hourString = '00';
  Timer? _timer;
  bool _isRunning = false;
  String _docIdState = '';
  String _time = '';
  int nowTotalSeconds = 0;
  int nowTotalMinutes = 0;
  int nowTotalHour = 0;
  int newTotalSeconds = 0;
  int newTotalMinutes = 0;
  int newTotalHour = 0;
  late DateTime startTime;
  late DateTime endTime;
  late Duration elapsedTime;
  late Timer timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    _docIdState = widget.docId;

    startTime = DateTime.now();
    elapsedTime = Duration.zero;
  }

  void record() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid.toString();

    final db = FirebaseFirestore.instance;
    final collectionReference =
        db.collection("users").doc(uid).collection('user_timers');

    try {
      QuerySnapshot querySnapshot = await collectionReference.get();

      for (var docSnapshot in querySnapshot.docs) {
        // データをMap<String, dynamic>?型に変換
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // fieldToRetrieveに取り出したいフィールドの名前を指定
          var nowTotalTime = data['total'];

          //今までの合計時間を取得
          nowTotalHour = int.parse(nowTotalTime[0] + nowTotalTime[1]);
          nowTotalMinutes = int.parse(nowTotalTime[2] + nowTotalTime[3]);
          nowTotalSeconds = int.parse(nowTotalTime[4] + nowTotalTime[5]);

          if (nowTotalTime != null) {
            print(
                'Specific Field Value: $nowTotalTime,$nowTotalHour,$nowTotalMinutes,$nowTotalSeconds');
          } else {
            print('Field not found or is null');
          }
        } else {
          print('Document data is null');
        }
      }
    } catch (e) {
      print("Error completing: $e");
    }

    //今までの合計時間と今計測した時間を足す
    newTotalSeconds = nowTotalSeconds + _seconds;
    newTotalMinutes = nowTotalMinutes + _minutes;
    newTotalHour = nowTotalHour + _hour;

    newTotalSeconds = nowTotalSeconds + seconds;
    newTotalMinutes = nowTotalMinutes + minutes;
    newTotalHour = nowTotalHour + hours;

    if (newTotalSeconds >= 60) {
      newTotalMinutes++;
      newTotalSeconds -= 60;
    }
    if (newTotalMinutes >= 60) {
      newTotalHour++;
      newTotalMinutes -= 60;
    }

    _secondsString = newTotalSeconds.toString();
    _minutesString = newTotalMinutes.toString();
    _hourString = newTotalHour.toString();

    _secondsString = _secondsString.padLeft(2, '0');
    _minutesString = _minutesString.padLeft(2, '0');
    _hourString = _hourString.padLeft(2, '0');

    _time = _hourString + _minutesString + _secondsString;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('user_timers')
        .doc(_docIdState)
        .update({'total': _time});
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          setState(() {
            elapsedTime = DateTime.now().difference(startTime);
          });
        },
      );
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  String formatElapsedTime(Duration duration) {
    int s_hours = duration.inHours;
    int s_minutes = duration.inMinutes.remainder(60);
    int s_seconds = duration.inSeconds.remainder(60);

    hours = s_hours;
    minutes = s_minutes;
    seconds = s_seconds;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '$s_hours:${twoDigits(s_minutes)}:${twoDigits(s_seconds)}';
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _minutes = 0;
      _hour = 0;
      _isRunning = false;

      elapsedTime = Duration.zero;
      startTime = DateTime.now();
      endTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    // アプリがフォアグラウンドに戻ってきたときに、endTimeを更新する
    endTime = DateTime.now();
    // elapsedTimeに時刻の差を加算する
    elapsedTime += endTime.difference(startTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatElapsedTime(elapsedTime),
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 125,
                  child: ElevatedButton(
                    onPressed: toggleTimer,
                    child: Text(
                      _isRunning ? 'ストップ' : 'スタート',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 125,
                  child: ElevatedButton(
                    onPressed: reset,
                    child: const Text(
                      'リセット',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 125,
                  child: ElevatedButton(
                    onPressed: record,
                    child: const Text(
                      '記録する',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
