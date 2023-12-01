import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/model/room.dart';

class RoomRepository extends ChangeNotifier {
  final _rooms = <Room>[];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int get count => _rooms.length;

  Future loadAllFromDatabase() async {
    _rooms.clear();

    // List of room instances
    List<Room> roomInstances = [FirstRoom(), SecondRoom(), LaptopRoom(), FifthRoom(), SwRoom()];

    for (Room room in roomInstances) {
      var collection = await FirebaseFirestore.instance.collection(room.name).get();
      room.initSeats();
      for (var doc in collection.docs) {
        int seatNum = int.parse(doc.id);  // Assuming that the document ID is the seat number
        bool seatState = doc.data()['seatState'];
        if (seatState) {
          room.use(seatNum);
        }
      }
      _rooms.add(room);
    }
    notifyListeners();
  }

  Future addOneToDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance.collection(room.name).doc(seatNum.toString()).set({
      'email': _auth.currentUser!.email,
      'seatState': true,
    });
    room.use(seatNum);
    notifyListeners();
  }

  Future updateOneToDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance.collection(room.name).doc(seatNum.toString()).update({
      'seatState': room.getSeat(seatNum)?.using,
    });
  }

  Future deleteOneFromDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance.collection(room.name).doc(seatNum.toString()).delete();
  }

  Room getRoom(String name) {
    return _rooms.firstWhere((room) => room.name == name);
  }
}