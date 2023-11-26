import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';
import 'package:myproject/model/seat.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Room room;
  int? selectedSeatIndex;
  Seat? get selectedSeat => room.getSeat(selectedSeatIndex);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    room = ModalRoute.of(context)!.settings.arguments as Room;
    setState(() {});
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
                    ? () {
                        int index = room.seats[i][j].index;
                        setState(() {
                          if (index == selectedSeatIndex) {
                            selectedSeatIndex = null;
                          } else {
                            selectedSeatIndex = index;
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듭니다.
      ),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: MyColorTheme.primary.withOpacity(.3),
          borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듭니다.
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '사용자: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Guest',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                selectedSeat!.using
                    ? Container()
                    : Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.alphaBlend(
                                MyColorTheme.primary.withOpacity(0.9),
                                Colors.white,
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 40)), // 버튼의 최소 크기 설정
                          ),
                          onPressed: () {
                            selectedSeat?.using = true;
                            setState(() {});
                          },
                          child: const Text('사용'),
                        ),
                      ),
              ],
            ), // Padding 위젯 안에 표시할 내용을 추가합니다.
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
