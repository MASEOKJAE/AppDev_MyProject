// ignore_for_file: use_build_context_synchronously

import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';
import 'package:myproject/model/seat.dart';
import 'package:myproject/model/room_repository.dart';
import 'package:myproject/model/user_repository.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key}) : super();

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Room room;
  int? selectedSeatIndex;
  Seat? get selectedSeat => room.getSeat(selectedSeatIndex);
  String? selectedUserEmail;
  late RoomRepository roomRepository;
  late UserRepository userRepository;
  bool isUserUsingSeat = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    roomRepository = Provider.of<RoomRepository>(context, listen: false);
    userRepository = Provider.of<UserRepository>(context, listen: false);
    room = ModalRoute.of(context)!.settings.arguments as Room;
    room = roomRepository.getRoom(room.name);
    userRepository.loadFavorite(room.name);
    isUserUsingSeat = room.seats.any((row) => row.any(
        (seat) => seat.using && seat.userEmail == UserRepository.user!.email));
    roomRepository.updateSeats(room);
  }

  Widget _buildSeatsWidget(BuildContext context) {
    const interval = 3.0;
    double width = MediaQuery.of(context).size.width;
    double height = width / room.size.width * room.size.height;
    double unitSize = width / room.size.width - interval;

    return Container(
      width: width,
      height: height,
      color: MyColorTheme.primary.withOpacity(.2),
      padding: const EdgeInsets.all(interval),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          room.size.height.toInt(),
          (i) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              room.size.width.toInt(),
              (j) => GestureDetector(
                onTap: room.seats[i][j].exist
                    ? () async {
                        int index = room.seats[i][j].index;
                        setState(() {
                          if (index == selectedSeatIndex) {
                            selectedSeatIndex = null;
                            selectedUserEmail = null;
                          } else {
                            selectedSeatIndex = index;
                            selectedUserEmail = room.seats[i][j].userEmail;
                          }
                        });
                      }
                    : null,
                child: Container(
                  width: unitSize,
                  height: unitSize,
                  decoration: BoxDecoration(
                    color: room.seats[i][j].exist
                        ? (room.seats[i][j].using ? Colors.red : Colors.green)
                        : Colors.transparent,
                    border: room.seats[i][j].index == selectedSeatIndex
                        ? Border.all(
                            width: 2.0,
                            color: Colors.black,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: room.seats[i][j].exist
                      ? Text(room.seats[i][j].index.toString())
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context) {
    if (selectedSeatIndex == null) return Container();

    _isFavorited =
        userRepository.isInFavorite(room.name, selectedSeatIndex.toString());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: MyColorTheme.primary.withOpacity(.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                            text: '자리 번호: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: selectedSeatIndex!.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_isFavorited) {
                          userRepository.removeFromFavorite(
                              room.name, selectedSeatIndex.toString());
                        } else {
                          userRepository.addToFavorite(
                              room.name, selectedSeatIndex.toString());
                        }
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                      child: Icon(_isFavorited ? Icons.star : Icons.star_border,
                          color: _isFavorited
                              ? Colors.yellow.shade600
                              : Colors.white),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: '현재 상태: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: selectedSeat!.using ? '사용 중' : '사용 가능',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: '사용자: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: selectedUserEmail ?? 'Guest',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                selectedSeat!.using
                    ? (selectedUserEmail == UserRepository.user!.email
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Add 'async' keyword
                                await roomRepository.deleteOneFromDatabase(room,
                                    selectedSeatIndex!); // Add 'await' keyword
                                setState(() {
                                  isUserUsingSeat = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('이제 다른 좌석을 사용하실 수 있습니다 :)'),
                                  ),
                                );
                                setState(() {});
                              },
                              child: const Text('떠나기'),
                            ),
                          )
                        : Container())
                    : (isUserUsingSeat
                        ? Container()
                        : Center(
                            child: ElevatedButton(
                              // ...
                              onPressed: () async {
                                // Add 'async' keyword
                                await roomRepository.addOneToDatabase(room,
                                    selectedSeatIndex!); // Add 'await' keyword
                                setState(() {
                                  isUserUsingSeat = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        '해당 좌석을 사용하시면, 다른 좌석은 사용하실 수 없습니다.'),
                                  ),
                                );
                                setState(() {});
                              },

                              child: const Text('사용'),
                            ),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(room.name)),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              _buildSeatsWidget(context),
              const SizedBox(
                height: 15,
              ),
              _infoCard(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
