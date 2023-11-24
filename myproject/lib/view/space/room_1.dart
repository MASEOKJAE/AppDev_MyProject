import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class Room1Page extends StatefulWidget {
  const Room1Page({Key? key}) : super(key: key);

  @override
  State<Room1Page> createState() => _Room1State();
}

class _Room1State extends State<Room1Page> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('room 1'),
      )
   );
  }
}