import 'package:flutter/material.dart';
//lib
import 'package:cloud_firestore/cloud_firestore.dart';
//firebase
import 'package:taimane_timemanager/timer_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _newUserEmail = '';
  String _newUserPass = '';

  Future<void> _showDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ログインに失敗しました'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('はい'),
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
      MaterialPageRoute(builder: (context) => const TimerListPage()),
    );
  }

  void _createAccount(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      addToFirebaseUser();

      _toTimerListPage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showDialog('パスワードが弱いです');
      } else if (e.code == 'email-already-in-use') {
        _showDialog('すでに使用されているメールアドレスです');
      } else {
        _showDialog('アカウント作成エラー');
      }
    }
  }

  void addToFirebaseUser() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid.toString();

    final db = FirebaseFirestore.instance;
    final users = <String, dynamic>{
      "email": _newUserEmail,
    };
    await db.collection("users").doc(uid).set(users);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (String value) {
                  setState(() {
                    _newUserEmail = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _newUserPass = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  _createAccount(_newUserEmail, _newUserPass);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('新規登録'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
