import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myproject/config/theme.dart';
import 'package:myproject/model/user.dart';
import 'package:myproject/model/user_repository.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoritePage> {
  final List<List<bool>> isAvailable = [
    [true, false, true, true, false],
    [false, true, true, false, true],
    [true, true, false, true, false],
    [false, false, true, false, true],
    [true, false, true, false, true],
  ];

  final List<String> areaNames = [
    '제 1열람실',
    '제 2열람실',
    '노트북 열림실',
    '제 5열람실',
    'SW 플라자',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColorTheme.primary,
        ),
      ),
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true, // 추가한 부분: 제목을 완벽하게 중앙에 위치시킴
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('즐겨찾는 자리'),
          actions: [
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return buildContainer(
                areaNames[index],
                isAvailable[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildContainer(String title, List<bool> isAvailableList) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: MyColorTheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                SizedBox(height: 10.0),
              ],
            ),
            subtitle: Wrap(
              // 수정한 부분: Wrap 위젯을 사용하여 자리가 많아질 경우에도 상자의 높이를 늘릴 수 있게 함
              spacing: 5.0, // 각 자리 사이의 간격
              runSpacing: 5.0,
              children: isAvailableList.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: CircleAvatar(
                    backgroundColor: entry.value ? Colors.green : Colors.red,
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}