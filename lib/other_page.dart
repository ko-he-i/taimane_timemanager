import 'package:flutter/material.dart';
import 'package:taimane_timemanager/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _deleteAccount() async {
    try {
      await _user?.delete();
      await _auth.signOut(); // サインアウト
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // ログインページに遷移
        ),
      );
    } catch (e) {
      print("アカウントを削除できませんでした：$e");
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("アカウントを削除しますか？"),
          content: const Text("この操作は取り消せません。"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () => _deleteAccount(),
              child: const Text("削除"),
            ),
          ],
        );
      },
    );
  }

  final contactUrl =
      Uri.parse('https://sites.google.com/view/timemanagerapp/contact');
  final privacyPolicyUrl =
      Uri.parse('https://sites.google.com/view/timemanagerapp/contact');

  void openContactUrl() async {
    if (await canLaunchUrl(contactUrl)) {
      await launchUrl(contactUrl);
    } else {
      throw 'お問い合わせを開けませんでした';
    }
  }

  void openPrivacyPolicyUrl() async {
    if (await canLaunchUrl(privacyPolicyUrl)) {
      await launchUrl(privacyPolicyUrl);
    } else {
      throw 'プライバシー・ポリシーを開けませんでした';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                openContactUrl();
              },
              child: const Text('お問い合わせ'),
            ),
            ElevatedButton(
              onPressed: () {
                openPrivacyPolicyUrl();
              },
              child: const Text('プライバシー・ポリシー'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_user != null) {
                  _showDeleteAccountDialog();
                } else {
                  print("ユーザーはログインしていません");
                }
              },
              child: const Text('アカウント削除'),
            ),
          ],
        ),
      ),
    );
  }
}
