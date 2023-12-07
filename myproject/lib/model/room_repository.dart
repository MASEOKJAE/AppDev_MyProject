import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/model/seat.dart';
import 'package:myproject/model/user.dart';

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
      SwRoom(),
    ];

    for (Room room in roomInstances) {
      room.initSeats();
      await updateSeats(room); // Update the seats state from Firestore
      _rooms.add(room);
    }
    notifyListeners();
  }

  Future<int> getAvailableSeats(String roomName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('rooms') // 'rooms' 컬렉션에 접근
      .doc(roomName)
      .collection('seats') // 각 room의 'seats' 컬렉션에 접근
      .get();
      
    int occupiedSeats = querySnapshot.docs.length;
    Room room = getRoom(roomName);
    int totalSeats = room.totalSeats;
    return totalSeats - occupiedSeats;
  }

  Future<void> updateSeats(Room room) async {
    for (var row in room.seats) {
      for (var seat in row) {
        if (seat.exist) {
          DocumentSnapshot seatSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(room.name)
            .collection('seats')
            .doc(seat.index.toString().padLeft(3, '0')) // '001' 형식으로 문서에 접근
            .get();
            
          if (seatSnapshot.exists) {
            String email = (seatSnapshot.data() as Map<String, dynamic>)['email'];
            seat.userEmail = email;
          }
        }
      }
    }
  }

  Future addOneToDatabase(Room room, int seatNum) async {
    User user = _auth.currentUser!;
    await FirebaseFirestore.instance
      .collection('rooms')
      .doc(room.name)
      .collection('seats')
      .doc(seatNum.toString().padLeft(3, '0'))
      .set({
        'email': user.email,
        'index': seatNum,
      });
    // room.use(seatNum, user);
    room.use(seatNum, UserModel(email: user.email, name: user.displayName));
    notifyListeners();
  }

  Future updateOneToDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance
      .collection('rooms')
      .doc(room.name)
      .collection('seats')
      .doc(seatNum.toString().padLeft(3, '0'))
      .update({
        'seatState': room.getSeat(seatNum)?.using,
      });
  }

  Future deleteOneFromDatabase(Room room, int seatNum) async {
    await FirebaseFirestore.instance
      .collection('rooms')
      .doc(room.name)
      .collection('seats')
      .doc(seatNum.toString().padLeft(3, '0'))
      .delete();
    room.getSeat(seatNum)?.leave();
    notifyListeners();
  }

  Room getRoom(String name) {
    return _rooms.firstWhere((room) => room.name == name);
  }

  Seat getSeat(String roomName, int seatNum) {
    Room room = getRoom(roomName);

    for (var row in room.seats) {
      for (var seat in row) {
        if (seat.exist && seat.index == seatNum) {
          return seat;
        }
      }
    }

    // If the seat is not found, return an empty seat
    return Seat.empty();
  }
}
