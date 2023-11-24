import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class Room5Page extends StatefulWidget {
  const Room5Page({Key? key}) : super(key: key);

  @override
  State<Room5Page> createState() => _Room5State();
}

class _Room5State extends State<Room5Page> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('room 5'),
      )
   );
  }
}