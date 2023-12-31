import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/model/room_repository.dart';
import 'package:provider/provider.dart';
import 'package:myproject/model/user_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  int favoriteLength = 0;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(milliseconds: 100), () async {
    //   UserRepository userRepo = Provider.of<UserRepository>(context, listen: false);
    //   favoriteLength = await userRepo.getFavoriteSeats();
    //   setState(() {});
    // });
  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    RoomRepository roomRepo = Provider.of<RoomRepository>(context);
    double height = 110;

    if (room.name == '제 2열람실') height = height * 3 + 40;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: Color.alphaBlend(
          MyColorTheme.primary.withOpacity(.3),
          Colors.white,
        ),
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/room', arguments: room);
          },
          borderRadius: BorderRadius.circular(10),
          highlightColor: Colors.black.withOpacity(.1),
          splashColor: Colors.black.withOpacity(.1),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('사용 가능'),
                          Text(
                            '${roomRepo.getUsingNum(room.name)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('전체 자리'),
                          Text(
                            '${room.offsets.length}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildRoomCard(context, FirstRoom()),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRoomCard(context, SecondRoom()),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildRoomCard(context, LaptopRoom()),
                    const SizedBox(height: 20),
                    _buildRoomCard(context, FifthRoom()),
                    const SizedBox(height: 20),
                    _buildRoomCard(context, SwRoom()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(BuildContext context, int index) {
    List<String> titles = ['홈', '즐겨찾기', '프로필', 'QR찾기', '동기부여', '설정'];
    List<String> routes = [
      '/',
      '/favorite',
      '/profile',
      '/qrscan',
      '/motivation',
      '/setting'
    ];
    List<IconData> icons = [
      Icons.home,
      Icons.star,
      Icons.account_circle,
      Icons.qr_code_scanner,
      Icons.hotel_class_sharp,
      Icons.settings,
    ];

    return ListTile(
      leading: Icon(icons[index], color: MyColorTheme.primary),
      title: Text(titles[index]),
      onTap: () {
        Navigator.pop(context);
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, routes[index], (route) => false);
          return;
        }
        Navigator.pushNamed(context, routes[index]);
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColorTheme.primary.withOpacity(.5),
            ),
            child: null,
          ),
          Column(
            children:
                List.generate(6, (index) => _buildDrawerTile(context, index)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepo = Provider.of<UserRepository>(context);

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              semanticLabel: 'profile',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: user?.displayName ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' 님\n환영합니다 :)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<int>(
              future: userRepo.getFavoriteSeats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('에러: ${snapshot.error}');
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/favorite');
                    },
                    borderRadius: BorderRadius.circular(10),
                    highlightColor: Colors.black.withOpacity(.1),
                    splashColor: Colors.black.withOpacity(.1),
                    child: Material(
                      color: Colors.transparent,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: MyColorTheme.primary.withOpacity(.3),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '즐겨찾기',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text('전체 자리'),
                                    Text(
                                      '${snapshot.data}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Expanded(child: _buildCards(context)),
          ],
        ),
      ),
    );
  }
}
