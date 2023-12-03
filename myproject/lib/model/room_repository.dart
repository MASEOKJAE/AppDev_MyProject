import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomRepository extends ChangeNotifier {
  final _rooms = <Room>[];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int get count => _rooms.length;

  Future loadAllFromDatabase() async {
    _rooms.clear();

    // List of room instances
    List<Room> roomInstances = [
      FirstRoom(),
      SecondRoom(),
      LaptopRoom(),
      FifthRoom(),
      SwRoom()
    ];

    for (Room room in roomInstances) {
      room.initSeats();
      await updateSeats(room); // Update the seats state from Firestore
      _rooms.add(room);
    }
    notifyListeners();
  }

  Future<void> updateSeat(Room room, int seatNum) async {
    for (var row in room.seats) {
      for (var seat in row) {
        if (seat.index == seatNum && seat.exist) {
          DocumentSnapshot seatSnapshot = await FirebaseFirestore.instance
              .collection(room.name)
              .doc(seat.index.toString())
              .get();
          if (seatSnapshot.exists) {
            bool using =
                (seatSnapshot.data() as Map<String, dynamic>)['seatState'] ??
                    false;
            seat.using = using;
          }
        }
      }
    }
  }

  Future<void> updateSeats(Room room) async {
    for (var row in room.seats) {
      for (var seat in row) {
        if (seat.exist) {
          DocumentSnapshot seatSnapshot = await FirebaseFirestore.instance
              .collection(room.name)
              .doc(seat.index.toString())
              .get();
          if (seatSnapshot.exists) {
            bool using =
                (seatSnapshot.data() as Map<String, dynamic>)['seatState'] ??
                    false;
            seat.using = using;
          }
        }
      }
    }
  }

  Future addOneToDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance
        .collection(room.name)
        .doc(seatNum.toString())
        .set({
      'email': _auth.currentUser!.email,
      'seatState': true,
    });
    room.use(seatNum);
    notifyListeners();
  }

  Future updateOneToDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance
        .collection(room.name)
        .doc(seatNum.toString())
        .update({
      'seatState': room.getSeat(seatNum)?.using,
    });
  }

  Future deleteOneFromDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance
        .collection(room.name)
        .doc(seatNum.toString())
        .delete();
  }

  Room getRoom(String name) {
    return _rooms.firstWhere((room) => room.name == name);
  }
}
