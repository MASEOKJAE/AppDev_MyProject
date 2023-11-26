class Seat {
  late int index;
  late bool exist;
  bool using = false;

  Seat.empty() { index = 0; exist = false; }
  Seat(this.index, {this.exist = false});

  void use() => using = true;
  void leave() => using = false;
}