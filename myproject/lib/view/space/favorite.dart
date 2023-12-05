import 'package:flutter/material.dart';
import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:myproject/model/room_repository.dart';
import 'package:myproject/model/user_repository.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoritePage> {
  late UserRepository userRepository;
  late RoomRepository roomRepository;
  List<String> areaNames = [];

  @override
  void initState() {
    super.initState();
    userRepository = Provider.of<UserRepository>(context, listen: false);
    roomRepository = Provider.of<RoomRepository>(context, listen: false);
  }

  Widget buildContainer(String title) {
    List<String> favoriteSeats = userRepository.favoriteItems[title] ?? [];
    Room room = roomRepository.getRoom(title);
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
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
                const SizedBox(height: 10.0),
              ],
            ),
            subtitle: Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              children: favoriteSeats.map((seatIndex) {
                bool isAvailable =
                    room.getSeat(int.parse(seatIndex))?.using ?? false;
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: CircleAvatar(
                    backgroundColor: isAvailable ? Colors.green : Colors.red,
                    child: Text(
                      seatIndex,
                      style: const TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 데이터 로드 중일 때 표시할 위젯
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return _buildUI(); // 데이터 로드가 완료되면 표시할 위젯
          }
        }
      },
    );
  }

  Future<void> _loadData() async {
    await userRepository.loadAllFromDatabase();
    await roomRepository.loadAllFromDatabase();
    areaNames = userRepository.favoriteItems.keys.toList();
    for (var area in areaNames) {
      await userRepository.loadFavorite(area);
    }
  }

  Widget _buildUI() {
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
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('즐겨찾는 자리'),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: areaNames.length,
            itemBuilder: (context, index) {
              return buildContainer(
                areaNames[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
