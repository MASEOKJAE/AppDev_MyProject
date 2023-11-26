import 'package:myproject/config/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingState();
}

class _SettingState extends State<SettingPage> {
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
                // add this
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: MyColorTheme.primary.withOpacity(.3),
                  borderRadius: BorderRadius.circular(
                      10.0), // change this to adjust the radius
                ),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
