import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myproject/config/theme.dart';
import 'package:myproject/model/seat.dart';
import 'package:qrcode_flutter/qrcode_flutter.dart';
import 'package:myproject/model/room_repository.dart';

class QrscanPage extends StatefulWidget {
  const QrscanPage({Key? key}) : super(key: key);

  @override
  State<QrscanPage> createState() => _QrscanState();
}

class _QrscanState extends State<QrscanPage> {
  RoomRepository _roomRepository = RoomRepository();
  bool _isSeatOccupied = false;
  String _captureText = '';
  QRCaptureController _captureController = QRCaptureController();

  @override
  void initState() {
    super.initState();
    _captureController.onCapture((data) async {
      setState(() {
        _captureText = data;
      });

      String roomName = _captureText.split(',')[0];
      int seatNum = int.parse(_captureText.split(',')[1]);

      // Use the roomRepository method to check if the seat is occupied
      Seat seat = _roomRepository.getSeat(roomName, seatNum);

      if (seat.exist && seat.using) {
        // Seat is occupied
        _isSeatOccupied = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Seat is occupied.'),
        ));
      } else {
        // Seat is available
        _isSeatOccupied = false;

        // You can use the addOneToDatabase method to claim the seat
        User user = FirebaseAuth.instance.currentUser!;
        await _roomRepository.addOneToDatabase(
            _roomRepository.getRoom(roomName), seatNum);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Seat is available. You can use it.'),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColorTheme.primary,
        title: const Text(
          'QR Seat Finder',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  child: QRCaptureView(
                    controller: _captureController,
                  ),
                ),
                Text(_captureText, style: TextStyle(color: Colors.black)),
                if (_isSeatOccupied)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/room_check',
                          arguments: _captureText);
                    },
                    child: Text('Seat Details'),
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      String roomName = _captureText.split(',')[0];
                      int seatNum = int.parse(_captureText.split(',')[1]);

                      // Check again if the seat is occupied (just in case)
                      Seat seat = _roomRepository.getSeat(roomName, seatNum);
                      if (seat.exist && seat.using) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Seat is occupied. Please choose another seat.'),
                        ));
                        return;
                      }

                      // Claim the seat
                      User user = FirebaseAuth.instance.currentUser!;
                      await _roomRepository.addOneToDatabase(
                          _roomRepository.getRoom(roomName), seatNum);

                      setState(() {
                        _isSeatOccupied = true;
                      });
                    },
                    child: Text('Use Seat'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
