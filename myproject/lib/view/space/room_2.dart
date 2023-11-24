import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class Room2Page extends StatefulWidget {
  const Room2Page({Key? key}) : super(key: key);

  @override
  State<Room2Page> createState() => _Room2State();
}

class _Room2State extends State<Room2Page> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}