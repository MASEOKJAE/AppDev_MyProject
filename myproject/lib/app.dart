import 'package:myproject/config/theme.dart';
import 'package:flutter/material.dart';

import 'view/home.dart';
import 'view/login.dart';
import 'view/profile.dart';
import 'view/setting.dart';
import 'view/space/favorite.dart';
import 'package:myproject/view/space/room_check.dart';

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
        '/profile': (BuildContext context) => const Profile(),
        '/favorite': (BuildContext context) => const FavoritePage(),
        '/setting': (BuildContext context) => const SettingPage(),
        '/room': (BuildContext context) => const RoomPage(),       
        // '/wishlist': (BuildContext context) => const WishListPage(),
      },
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColorTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}