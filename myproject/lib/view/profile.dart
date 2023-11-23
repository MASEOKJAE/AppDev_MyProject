import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? _user;
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    await _userRepository.loadAllFromDatabase();
    setState(() {
      _user = _userRepository.getUser(user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        user?.photoURL ?? "http://handong.edu/site/handong/res/img/logo.png";
    String uid = user?.uid ?? 'Anonymous UID';
    String email = user?.email ?? 'Anonymous';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: CachedNetworkImageProvider(imageUrl),
                    ),
                    // shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 70),
            Text(
              '<$uid>',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 1.0,
              thickness: 1,
              color: Colors.white,
            ),
            const SizedBox(height: 30),
            Text(
              email,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Seokjae Ma',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              _user?.statusMessage ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
