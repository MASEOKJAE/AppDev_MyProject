import 'package:myproject/config/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        user?.photoURL ?? "http://handong.edu/site/handong/res/img/logo.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page'),
        centerTitle: true,
        // backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, '/location');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: CachedNetworkImageProvider(imageUrl),
                        ),
                        // shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '회원 정보',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0), // 원하는 패딩 값을 설정
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: '이름:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: user?.displayName ?? 'Guest',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: '학교 메일:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: user?.email,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: '연락처:  ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: user?.phoneNumber ?? '010-1234-1234',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    children: [
                      Text(
                        '업적 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.emoji_events, // 트로피 아이콘
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      // add this
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 150,
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
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    children: [
                      Text(
                        '경고 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.warning,
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      // add this
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      height: 150,
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
            ],
          ),
        ),
      ),
    );
  }
}
