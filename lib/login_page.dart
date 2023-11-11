import 'package:flutter/material.dart';
//lib
import 'package:taimane_timemanager/registration_page.dart';
import 'package:taimane_timemanager/timer.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taimane_timemanager/timer_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmailAddress = '';
  String loginEmailPassword = '';
  List timer = [];

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

  Future<void> _showDialog(String message1, String message2) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ログインに失敗しました'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message1),
                Text(message2),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toTimerListPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TimerListPage(),
      ),
    );
  }

  void _login(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      _toTimerListPage();
    } on FirebaseAuthException catch (e) {
      String message = 'ログインに失敗しました';
      if (e.code == 'user-not-found') {
        message = 'ユーザーが見つかりませんでした。';
      } else if (e.code == 'wrong-password') {
        message = 'パスワードが間違っています。';
      }
      _showDialog('ログインに失敗しました', message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'タイマネ/Time Manager',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (String value) {
                  loginEmailAddress = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                ),
                onChanged: (String value) {
                  loginEmailPassword = value;
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  _login(loginEmailAddress, loginEmailPassword);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ログイン'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}
