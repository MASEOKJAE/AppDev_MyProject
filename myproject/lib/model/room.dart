import 'package:myproject/model/seat.dart';
import 'package:flutter/material.dart';

abstract class Room {
  late String name;
  late Size size;
  late List<Offset> offsets;
  late List<List<Seat>> seats;
}

class LaptopRoom extends Room {
  @override
  String get name => '노트북 열람실';

  @override
  Size get size => const Size(9, 14);

  @override
  List<Offset> get offsets => const [
    Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(0, 5), Offset(0, 6), Offset(1, 8), Offset(2, 8), Offset(4, 8), Offset(5, 8), Offset(7, 8), Offset(8, 8), Offset(9, 8), Offset(11, 8), Offset(12, 8), Offset(13, 8), Offset(3, 1), Offset(4, 1), Offset(5, 1), Offset(7, 1), Offset(8, 1), Offset(9, 1), Offset(11, 1), Offset(12, 1), Offset(13, 1), Offset(3, 2), Offset(4, 2), Offset(5, 2), Offset(7, 2), Offset(8, 2), Offset(9, 2), Offset(11, 2), Offset(12, 2), Offset(13, 2), Offset(3, 4), Offset(4, 4), Offset(5, 4), Offset(7, 4), Offset(8, 4), Offset(9, 4), Offset(11, 4), Offset(12, 4), Offset(13, 4), Offset(3, 5), Offset(4, 5), Offset(5, 5), Offset(7, 5), Offset(8, 5), Offset(9, 5), Offset(11, 5), Offset(12, 5), Offset(13, 5)
  ];

  void initSeats() {
    seats = List.generate(
      size.height.toInt(), (i) => List.generate(
      size.width.toInt(), (j) => Seat.empty()),
    );

    for (int i = 0; i < offsets.length; i++) {
      int x = offsets[i].dx.toInt();
      int y = offsets[i].dy.toInt();
      seats[x][y] = Seat(i + 1, exist: true);
    }
  }

  LaptopRoom() { initSeats(); }
}