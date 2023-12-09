import 'package:myproject/model/seat.dart';
import 'package:flutter/material.dart';
import 'package:myproject/model/user.dart';


abstract class Room {
  late String name;
  late Size size;
  late List<Offset> offsets;
  late List<List<Seat>> seats;
  int get totalSeats => offsets.length;

  List<Seat> get seatList => seats.expand((x) => x).toList();

  Seat? getSeat(int? index) {
    if (index == null) return null;
    int x = offsets[index - 1].dx.toInt();
    int y = offsets[index - 1].dy.toInt();
    return seats[x][y];
  }

  void initSeats();
  void use(int index, UserModel user) => getSeat(index)?.use(user);

}

class FirstRoom extends Room {
  @override
  String get name => '제 1열람실';

  @override
  Size get size => const Size(25, 20);

  @override
  List<Offset> get offsets => const [
    Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(0, 4), Offset(1, 0), Offset(1, 1), Offset(1, 2), Offset(1, 3), Offset(1, 4), Offset(3, 0), Offset(3, 1), Offset(3, 2), Offset(3, 3), Offset(3, 4), Offset(4, 0), Offset(4, 1), Offset(4, 2), Offset(4, 3), Offset(4, 4), Offset(6, 0), Offset(6, 1), Offset(6, 2), Offset(6, 3), Offset(6, 4), Offset(7, 0), Offset(7, 1), Offset(7, 2), Offset(7, 3), Offset(7, 4), Offset(9, 0), Offset(9, 1), Offset(9, 2), Offset(9, 3), Offset(9, 4), Offset(10, 0), Offset(10, 1), Offset(10, 2), Offset(10, 3), Offset(10, 4), Offset(12, 0), Offset(12, 1), Offset(12, 2), Offset(12, 3), Offset(12, 4), Offset(13, 0), Offset(13, 1), Offset(13, 2), Offset(13, 3), Offset(13, 4), Offset(15, 0), Offset(15, 1), Offset(15, 2), Offset(15, 3), Offset(15, 4), Offset(16, 0), Offset(16, 1), Offset(16, 2), Offset(16, 3), Offset(16, 4), Offset(18, 0), Offset(18, 1), Offset(18, 2), Offset(18, 3), Offset(18, 4), Offset(19, 0), Offset(19, 1), Offset(19, 2), Offset(19, 3), Offset(19, 4), Offset(0, 6), Offset(0, 7), Offset(0, 8), Offset(0, 9), Offset(3, 6), Offset(3, 7), Offset(3, 8), Offset(3, 9), Offset(4, 6), Offset(4, 7), Offset(4, 8), Offset(4, 9), Offset(6, 6), Offset(6, 7), Offset(6, 8), Offset(6, 9), Offset(7, 6), Offset(7, 7), Offset(7, 8), Offset(7, 9), Offset(9, 6), Offset(9, 7), Offset(9, 8), Offset(9, 9), Offset(10, 6), Offset(10, 7), Offset(10, 8), Offset(10, 9), Offset(12, 6), Offset(12, 7), Offset(12, 8), Offset(12, 9), Offset(13, 6), Offset(13, 7), Offset(13, 8), Offset(13, 9), Offset(15, 6), Offset(15, 7), Offset(15, 8), Offset(15, 9), Offset(16, 6), Offset(16, 7), Offset(16, 8), Offset(16, 9), Offset(18, 6), Offset(18, 7), Offset(18, 8), Offset(18, 9), Offset(19, 6), Offset(19, 7), Offset(19, 8), Offset(19, 9), Offset(0, 11), Offset(1, 11), Offset(2, 11), Offset(3, 11), Offset(4, 11), Offset(5, 11), Offset(6, 11), Offset(1, 13), Offset(2, 13), Offset(3, 13), Offset(4, 13), Offset(5, 13), Offset(6, 13), Offset(0, 15), Offset(0, 16), Offset(0, 17), Offset(0, 18), Offset(0, 19), Offset(0, 20), Offset(0, 21), Offset(0, 22), Offset(2, 15), Offset(2, 16), Offset(2, 17), Offset(2, 18), Offset(2, 19), Offset(2, 20), Offset(2, 21), Offset(2, 22), Offset(2, 23), Offset(2, 24), Offset(3, 15), Offset(3, 16), Offset(3, 17), Offset(3, 18), Offset(3, 19), Offset(3, 20), Offset(3, 21), Offset(3, 22), Offset(3, 23), Offset(3, 24), Offset(5, 15), Offset(5, 16), Offset(5, 17), Offset(5, 18), Offset(5, 19), Offset(5, 20), Offset(5, 21), Offset(5, 22), Offset(5, 23), Offset(5, 24), Offset(6, 15), Offset(6, 16), Offset(6, 17), Offset(6, 18), Offset(6, 19), Offset(6, 20), Offset(6, 21), Offset(6, 22), Offset(6, 23), Offset(6, 24), Offset(8, 15), Offset(8, 16), Offset(8, 17), Offset(8, 18), Offset(8, 19), Offset(8, 20), Offset(8, 21), Offset(8, 22), Offset(8, 23), Offset(8, 24), Offset(9, 15), Offset(9, 16), Offset(9, 17), Offset(9, 18), Offset(9, 19), Offset(9, 20), Offset(9, 21),
  ];

  @override
  initSeats() {
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

  FirstRoom() { initSeats(); }
}

class SecondRoom extends Room {
  @override
  String get name => '제 2열람실';

  @override
  Size get size => const Size(10, 20);

  @override
  List<Offset> get offsets => const [
    Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(0, 4), Offset(1, 0), Offset(1, 1), Offset(1, 2), Offset(1, 3), Offset(1, 4), Offset(3, 0), Offset(3, 1), Offset(3, 2), Offset(3, 3), Offset(3, 4), Offset(4, 0), Offset(4, 1), Offset(4, 2), Offset(4, 3), Offset(4, 4), Offset(6, 0), Offset(6, 1), Offset(6, 2), Offset(6, 3), Offset(6, 4), Offset(7, 0), Offset(7, 1), Offset(7, 2), Offset(7, 3), Offset(7, 4), Offset(9, 0), Offset(9, 1), Offset(9, 2), Offset(9, 3), Offset(9, 4), Offset(10, 0), Offset(10, 1), Offset(10, 2), Offset(10, 3), Offset(10, 4), Offset(12, 0), Offset(12, 1), Offset(12, 2), Offset(12, 3), Offset(12, 4), Offset(13, 0), Offset(13, 1), Offset(13, 2), Offset(13, 3), Offset(13, 4), Offset(15, 0), Offset(15, 1), Offset(15, 2), Offset(15, 3), Offset(15, 4), Offset(16, 0), Offset(16, 1), Offset(16, 2), Offset(16, 3), Offset(16, 4), Offset(18, 0), Offset(18, 1), Offset(18, 2), Offset(18, 3), Offset(18, 4), Offset(19, 0), Offset(19, 1), Offset(19, 2), Offset(19, 3), Offset(19, 4), Offset(0, 6), Offset(0, 7), Offset(0, 8), Offset(0, 9), Offset(1, 6), Offset(1, 7), Offset(1, 8), Offset(1, 9), Offset(3, 6), Offset(3, 7), Offset(3, 8), Offset(3, 9), Offset(4, 6), Offset(4, 7), Offset(4, 8), Offset(4, 9), Offset(6, 6), Offset(6, 7), Offset(6, 8), Offset(6, 9), Offset(7, 6), Offset(7, 7), Offset(7, 8), Offset(7, 9), Offset(9, 6), Offset(9, 7), Offset(9, 8), Offset(9, 9), Offset(10, 6), Offset(10, 7), Offset(10, 8), Offset(10, 9), Offset(12, 6), Offset(12, 7), Offset(12, 8), Offset(12, 9), Offset(13, 6), Offset(13, 7), Offset(13, 8), Offset(13, 9), Offset(15, 6), Offset(15, 7), Offset(15, 8), Offset(15, 9), Offset(16, 6), Offset(16, 7), Offset(16, 8), Offset(16, 9), Offset(18, 6), Offset(18, 7), Offset(18, 8), Offset(18, 9), Offset(19, 6), Offset(19, 7), Offset(19, 8), Offset(19, 9),
  ];

  @override
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

  SecondRoom() { initSeats(); }
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

  @override
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

class FifthRoom extends Room {
  @override
  String get name => '제 5열람실';

  @override
  Size get size => const Size(11, 20);

  @override
  List<Offset> get offsets => const [
    Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(0, 4), Offset(0, 9), Offset(0, 10), Offset(2, 0), Offset(2, 1), Offset(2, 2), Offset(3, 0), Offset(3, 1), Offset(3, 2), Offset(2, 8), Offset(2, 9), Offset(2, 10), Offset(3, 8), Offset(3, 9), Offset(3, 10), Offset(5, 0), Offset(5, 1), Offset(5, 2), Offset(6, 0), Offset(6, 1), Offset(6, 2), Offset(5, 8), Offset(5, 9), Offset(5, 10), Offset(6, 8), Offset(6, 9), Offset(6, 10), Offset(8, 0), Offset(8, 1), Offset(8, 2), Offset(9, 0), Offset(9, 1), Offset(9, 2), Offset(8, 8), Offset(8, 9), Offset(8, 10), Offset(9, 8), Offset(9, 9), Offset(9, 10), Offset(11, 0), Offset(11, 1), Offset(11, 2), Offset(12, 0), Offset(12, 1), Offset(12, 2), Offset(11, 8), Offset(11, 9), Offset(11, 10), Offset(12, 8), Offset(12, 9), Offset(12, 10), Offset(14, 0), Offset(15, 0), Offset(16, 0), Offset(17, 0), Offset(18, 0), Offset(19, 0), Offset(14, 8), Offset(15, 8), Offset(16, 8), Offset(17, 8), Offset(18, 8), Offset(19, 8),
  ];

  @override
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

  FifthRoom() { initSeats(); }
}

class SwRoom extends Room {
  @override
  String get name => 'SW 플라자';

  @override
  Size get size => const Size(15, 16);

  @override
  List<Offset> get offsets => const [
    Offset(2, 1), Offset(2, 2), Offset(2, 3), Offset(3, 1), Offset(3, 2), Offset(3, 3), Offset(2, 6), Offset(2, 7), Offset(3, 6), Offset(3, 7), Offset(5, 1), Offset(5, 2), Offset(5, 3), Offset(6, 1), Offset(6, 2), Offset(6, 3), Offset(5, 6), Offset(5, 7), Offset(6, 6), Offset(6, 7), Offset(8, 1), Offset(8, 2), Offset(8, 3), Offset(9, 1), Offset(9, 2), Offset(9, 3), Offset(8, 6), Offset(8, 7), Offset(9, 6), Offset(9, 7), Offset(11, 1), Offset(11, 2), Offset(11, 3), Offset(12, 1), Offset(12, 2), Offset(12, 3), Offset(11, 6), Offset(11, 7), Offset(12, 6), Offset(12, 7), Offset(2, 10), Offset(2, 11), Offset(3, 10), Offset(3, 11), Offset(5, 10), Offset(5, 11), Offset(6, 10), Offset(6, 11), Offset(8, 10), Offset(8, 11), Offset(9, 10), Offset(9, 11), Offset(11, 10), Offset(11, 11), Offset(12, 10), Offset(12, 11), Offset(0, 14), Offset(1, 14), Offset(2, 14), Offset(3, 14), Offset(4, 14), Offset(5, 14), Offset(6, 14), Offset(9, 14), Offset(10, 14), Offset(11, 14), Offset(12, 14), Offset(13, 14), Offset(14, 14), Offset(15, 14),
  ];

  @override
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

  SwRoom() { initSeats(); }
}