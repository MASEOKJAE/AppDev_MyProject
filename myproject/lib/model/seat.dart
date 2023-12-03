class Seat {
  late int index;
  late bool exist;
  bool using = false;
  String userEmail = '?';

  Seat.empty() { 
    index = 0; 
    exist = false; 
    userEmail = '?';
  }
  Seat(this.index, {this.exist = false, this.userEmail = '?'});

  void use() => using = true;
  void leave() => using = false;
}
