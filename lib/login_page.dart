import 'package:flutter/material.dart';
//lib
import 'package:taimane_timemanager/registration_page.dart';
//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taimane_timemanager/timer_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginEmailAddress = '';
  String loginEmailPassword = '';

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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showDialog('ユーザーが見つかりませんでした', 'メールアドレスを正しく入力してください');
      } else if (e.code == 'wrong-password') {
        _showDialog('パスワードが間違っています', 'パスワードを正しく入力してください');
      }
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
                  _toTimerListPage();
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
