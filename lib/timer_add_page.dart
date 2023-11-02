import 'dart:async';
import 'package:flutter/material.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimerAddPage extends StatelessWidget {
  const TimerAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    String timerName = '';

    Future addToFirebase() async {
      final auth = FirebaseAuth.instance;
      final uid = auth.currentUser?.uid.toString();

      final timerData = <String, dynamic>{
        "timerName": timerName,
        "total": '000000',
        "id": uid,
      };

      final timerRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('user_timers');
      await timerRef.add(timerData);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new timer'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'New timer name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  timerName = text;
                },
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  await addToFirebase();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
