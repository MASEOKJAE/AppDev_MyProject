import 'package:finalterm_project/config/theme.dart';
import 'package:finalterm_project/view/space/room.dart';
import 'package:flutter/material.dart';

import 'view/home.dart';
import 'view/login.dart';
import 'view/profile.dart';
import 'view/space/favorite.dart';
import 'view/space/room_1.dart';
import 'view/space/room_2.dart';
import 'view/space/room_laptop.dart';
import 'view/space/room_5.dart';
import 'view/space/room_sw.dart';
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
        '/room': (BuildContext context) => const RoomPage(),
        // '/room1': (BuildContext context) => const Room1Page(),
        // '/room2': (BuildContext context) => const Room2Page(),
        // '/roomlaptop': (BuildContext context) => const RoomLaptopPage(),
        // '/room5': (BuildContext context) => const Room5Page(),
        // '/roomsw': (BuildContext context) => const RoomSwPage(),
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