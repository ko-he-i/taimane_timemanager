import 'package:flutter/material.dart';
//firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taimane_timemanager/timer_page.dart';
//lib
import 'package:taimane_timemanager/timer.dart';
import 'package:taimane_timemanager/timer_add_page.dart';
import 'package:taimane_timemanager/other_page.dart';

class TimerListPage extends StatefulWidget {
  const TimerListPage({super.key});

  @override
  State<TimerListPage> createState() => _TimerListPageState();
}

class _TimerListPageState extends State<TimerListPage> {
  List timer = [];
  String docId = '';

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  void _fetchFirebaseData() async {
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
      body: ListView(
        children: timer
            .map((timer) => Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  child: ListTile(
                    title: Text(timer.timerName),
                    trailing: Text(
                        '合計：${timer.total[0] + timer.total[1]}時間${timer.total[2] + timer.total[3]}分'),
                    onTap: () async {
                      docId = timer.id;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimerPage(docId: docId)),
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
                                      .doc(timer.id)
                                      .delete();
                                  _fetchFirebaseData();
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
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimerAddPage()),
          );
          _fetchFirebaseData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
