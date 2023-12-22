import 'package:flutter/material.dart';
import 'package:taimane_timemanager/registration_page.dart';
import 'package:taimane_timemanager/screens_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login(BuildContext context) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Future.delayed(Duration.zero, () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScreensPage(),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        String message = 'ログインに失敗しました';
        if (e.code == 'user-not-found') {
          message = 'ユーザーが見つかりませんでした。';
        } else if (e.code == 'wrong-password') {
          message = 'パスワードが間違っています。';
        }
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ログインに失敗しました'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const Text('ログインに失敗しました'),
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
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログインページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.1,
              child: const Text(
                'タイマネ/Time Manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.95,
              height: size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.95,
              height: size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'パスワード',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  login(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ログイン'),
              ),
            ),
            SizedBox(
              width: size.width * 0.3,
              height: size.height * 0.05,
              child: TextButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
