// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/hguLogo.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(200, 50)), // 버튼의 최소 크기 설정
                ),
                onPressed: () async {
                  await signInWithGoogle();
                  await Provider.of<ProductRepository>(context, listen: false)
                      .loadAllFromDatabase();
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: const Text('Google Login'),
              ),
              const SizedBox(height: 10,),
              
              // ElevatedButton(
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all<Size>(
              //         const Size(200, 50)), // 버튼의 최소 크기 설정
              //   ),
              //   onPressed: () async {
              //     await signInAnonymously();
              //     await Provider.of<ProductRepository>(context, listen: false)
              //         .loadAllFromDatabase();
              //     Navigator.pushReplacementNamed(context, '/');
              //   },
              //   child: const Text('Guest Login'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
