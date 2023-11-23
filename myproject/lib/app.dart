import 'package:flutter/material.dart';

import 'view/home.dart';
import 'view/login.dart';
import 'view/profile.dart';
// import 'view/add.dart';
// import 'view/detail.dart';
// import 'view/modify.dart';
// import 'view/wishlist.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class StudyApp extends StatelessWidget {
  const StudyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => const HomePage(),
        // '/add': (BuildContext context) => const AddPage(),
        '/profile': (BuildContext context) => const Profile(),
        // '/detail': (BuildContext context) => const DetailPage(),
        // '/modify': (BuildContext context) => const ModifyPage(),
        // '/wishlist': (BuildContext context) => const WishListPage(),
      },
      // TODO: Customize the theme (103)
      theme: ThemeData.light(useMaterial3: false),
      debugShowCheckedModeBanner: false,
    );
  }
}