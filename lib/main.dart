import 'package:flutter/material.dart';
import 'package:taimane_timemanager/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taimane_timemanager/timer_list_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //←コレ
      title: 'タイマネ/Time Manager',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // スプラッシュ画面などに書き換えても良い
            return const SizedBox();
          }
          if (snapshot.hasData) {
            // User が null でなない、つまりサインイン済みのホーム画面へ
            return const TimerListPage();
          }
          // User が null である、つまり未サインインのサインイン画面へ
          return const LoginPage();
        },
      ),
    );
  }
}
