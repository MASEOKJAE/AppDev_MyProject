import 'package:myproject/model/user.dart';

class Seat {
  late int index;
  late bool exist;
  String? userEmail;

  bool get using => userEmail != null;

  Seat.empty() { 
    index = 0; 
    exist = false;
  }
  Seat(this.index, {this.exist = false, this.userEmail});

  void use(UserModel user) => userEmail = user.email;
  void leave() => userEmail = null;
}
