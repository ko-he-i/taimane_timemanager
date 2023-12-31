import 'package:flutter/material.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taimane_timemanager/pra_page.dart';
import 'package:taimane_timemanager/screens_page.dart';
import 'package:taimane_timemanager/timer_page.dart';
//lib
import 'package:taimane_timemanager/timer.dart';
import 'package:taimane_timemanager/timer_add_page.dart';
import 'package:taimane_timemanager/other_page.dart';

class TimerList extends StatefulWidget {
  const TimerList({super.key});

  @override
  State<TimerList> createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  List timer = [];
  String docId = '';

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  void _fetchFirebaseData() async {
    try {
      final auth = FirebaseAuth.instance;
      final uid = auth.currentUser?.uid.toString();

      final db = FirebaseFirestore.instance;
      final event =
          await db.collection("users").doc(uid).collection('user_timers').get();
      final docs = event.docs;
      final timer = docs.map((doc) => Timer.fromFirestore(doc)).toList();

      setState(() {
        this.timer = timer;
      });
    } catch (e) {
      print('データの取得に失敗しました: $e');
    }
  }

  String formatTimeString(String input) {
    if (input.length != 4) {
      return '';
    }

    String hours = input.substring(0, 2);
    String minutes = input.substring(2, 4);

    return '$hours時間$minutes分';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OtherPage()),
              );
              _fetchFirebaseData();
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: timer.length,
        itemBuilder: (context, index) {
          final timerItem = timer[index];
          return Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
              ),
            ),
            child: ListTile(
              title: Text(timerItem.timerName),
              trailing: Text(
                '合計：${timerItem.total[0] + timerItem.total[1]}時間${timerItem.total[2] + timerItem.total[3]}分',
              ),
              onTap: () async {
                docId = timerItem.id;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(docId: docId),
                  ),
                );
                _fetchFirebaseData();
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('削除しますか？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final auth = FirebaseAuth.instance;
                            final uid = auth.currentUser?.uid.toString();
                            final db = FirebaseFirestore.instance;
                            await db
                                .collection('users')
                                .doc(uid)
                                .collection('user_timers')
                                .doc(timerItem.id)
                                .delete();

                            setState(() {
                              timer.remove(timerItem); // 該当の要素を削除
                            });

                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LineChartSample2()),
          );
          _fetchFirebaseData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
