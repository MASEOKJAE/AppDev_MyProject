import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  late String uid;
  String? name;
  String? email;
  String? statusMessage;

  UserModel({required this.email, this.name});

  UserModel.fromCredential(UserCredential credential) {
    uid = credential.user!.uid;
    name = credential.user!.displayName;
    email = credential.user!.email;
  }
  
  UserModel.fromJson(this.uid, Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    statusMessage = json['status_message'];
  }
}