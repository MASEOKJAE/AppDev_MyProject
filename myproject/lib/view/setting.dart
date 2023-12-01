import 'package:myproject/config/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: MyColorTheme.primary.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('다크 모드', style: TextStyle(fontSize: 20)),
                      ),
                      Switch(
                        value: _isSwitched,
                        onChanged: (value) {
                          setState(() {
                            _isSwitched = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: MyColorTheme.primary.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('이용 약관', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10.0),
                          Text('이용 약관의 세부사항...'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: MyColorTheme.primary.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('소프트웨어 버전', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10.0),
                          Text('ver 0.0.5'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}