import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class RoomSwPage extends StatefulWidget {
  const RoomSwPage({Key? key}) : super(key: key);

  @override
  State<RoomSwPage> createState() => _RoomSwState();
}

class _RoomSwState extends State<RoomSwPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();
  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text('room sw'),
      )
   );
  }
}