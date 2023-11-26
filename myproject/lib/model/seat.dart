class Seat {
  late int index;
  late bool exist;
  bool using = false;
  late String userEmail;

  Seat.empty() { index = 0; exist = false; userEmail = '?';}
  Seat(this.index, {this.exist = false});

  void use() => using = true;
  void leave() => using = false;
}