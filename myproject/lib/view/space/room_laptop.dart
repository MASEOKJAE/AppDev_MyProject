import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class RoomLaptopPage extends StatefulWidget {
  const RoomLaptopPage({Key? key}) : super(key: key);

  @override
  State<RoomLaptopPage> createState() => _RoomLaptopState();
}

class _RoomLaptopState extends State<RoomLaptopPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}