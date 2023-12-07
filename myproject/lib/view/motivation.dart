import 'package:flutter/material.dart';
import 'package:myproject/model/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myproject/view/widget/stopwatch.dart'; // stopwatch.dart를 import 합니다.

class MotivationPage extends StatefulWidget {
  const MotivationPage({Key? key}) : super(key: key);

  @override
  State<MotivationPage> createState() => _MotivationState();
}

class _MotivationState extends State<MotivationPage> {
  DateTime? scheduledTime;
  String imageUrl = '';
  final _stopWatchWidget = StopWatch(); // StopWatch instance

  @override
  void initState() {
    super.initState();
    LocalNotification.init();
    _loadScheduledTime();
    _setMotivationImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              '예약한 알림 시간: ${scheduledTime != null ? '${scheduledTime!.hour}:${scheduledTime!.minute}' : '설정되지 않음'}',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(),
              child: const Text('목표 시간 선택'),
            ),
            const SizedBox(
              height: 100,
            ),
            Expanded(
              // Add Expanded here
              child: _stopWatchWidget, // Use StopWatch widget here
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        scheduledTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // 알림 예약 및 남은 시간 계산
        LocalNotification.scheduleNotification(scheduledTime!);

        // 예약한 시간을 SharedPreferences에 저장
        _saveScheduledTime(scheduledTime!);
        _setMotivationImage();
      });
    }
  }

  void _loadScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduledTimeMillis =
        prefs.getInt('scheduledTime') ?? DateTime.now().millisecondsSinceEpoch;
    setState(() {
      scheduledTime = DateTime.fromMillisecondsSinceEpoch(scheduledTimeMillis);
    });
  }

  void _saveScheduledTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('scheduledTime', time.millisecondsSinceEpoch);
  }

  void _setMotivationImage() {
    // 여기서 scheduledTime에 따라 다양한 모티베이션 이미지 경로 설정
    // 예시로 현재 시간이 짝수시인지 홀수시인지에 따라 이미지를 선택
    if (scheduledTime != null && scheduledTime!.hour.isEven) {
      setState(() {
        imageUrl =
            'https://cdn.pixabay.com/photo/2020/09/09/04/46/dream-big-work-hard-5556539_1280.jpg';
      });
    } else {
      setState(() {
        imageUrl =
            'https://cdn.pixabay.com/photo/2019/04/29/14/32/make-the-day-great-4166221_1280.jpg';
      });
    }
  }
}
