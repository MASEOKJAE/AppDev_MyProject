import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Room room;

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
      width: width, height: height,
      color: MyColorTheme.primary.withOpacity(.2),
      padding: const EdgeInsets.all(interval),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          room.size.height.toInt(), (i) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              room.size.width.toInt(), (j) => Container(
                width: unitSize, height: unitSize,
                color: room.seats[i][j].exist
                    ? Colors.grey
                    : Colors.transparent,
                alignment: Alignment.center,
                child: room.seats[i][j].exist
                    ? Text(room.seats[i][j].index.toString())
                    : null,
              ),
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [_buildSeatsWidget(context)],
        ),
      ),
    );
  }
}
