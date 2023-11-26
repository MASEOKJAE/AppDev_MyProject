// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/config/theme.dart';
import 'package:myproject/model/product_repository.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Firebase 인증과 Google 로그인을 위한 인스턴스 생성
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    // Google 로그인 프로세스 진행
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // 사용자가 로그인에 성공하면, 해당 사용자 계정의 인증 정보를 얻음
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Google 로그인에서 얻은 인증 정보를 바탕으로 Firebase 인증 정보 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Firestore에 사용자 정보 저장
    // SetOptions(merge: true)는 이미 동일한 uid로 저장된 데이터가 있다면,
    // 새로운 데이터로 병합(merge)하라는 의미
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': userCredential.user!.displayName,
      'email': userCredential.user!.email,
      'uid': userCredential.user!.uid,
      'status_message': 'I promise to take the test honestly before GOD.',
    }, SetOptions(merge: true));

    // Firestore에서 사용자 정보 로드
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    final user = UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);

    UserRepository.login(user);
  }

  Future<void> signInAnonymously() async {
    // 익명 로그인 프로세스 진행
    final UserCredential userCredential = await _auth.signInAnonymously();

    // Firestore에 사용자 정보 저장
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'status_message': 'I promise to take the test honestly before GOD.',
    }, SetOptions(merge: true));

    // Firestore에서 사용자 정보 로드
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();
    final user = UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);

    UserRepository.login(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(
        MyColorTheme.primary.withOpacity(.7),
        Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(70.0, 50.0, 70.0, 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/mainLogo.svg',
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'A Space Ignited by \nthe Passion for Learning',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 200,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.alphaBlend(
                      MyColorTheme.primary.withOpacity(0.9),
                      Colors.white,
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(200, 60)), // 버튼의 최소 크기 설정
                ),
                onPressed: () async {
                  await signInWithGoogle();
                  await Provider.of<ProductRepository>(context, listen: false)
                      .loadAllFromDatabase();
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/google.svg',
                        width: 30, height: 30),
                    const SizedBox(width: 20),
                    const Text(
                      'Login in with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
