import 'package:myproject/config/theme.dart';
import 'package:myproject/model/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;

  final List<String> entries = <String>[
    '즐겨찾기',
    '제1열람실',
  ];
  final List<int> colorCodes = <int>[600, 500, 100, 600, 500, 100];

  Widget _buildCard(BuildContext context, {
    required String title,
    Widget? child,
    VoidCallback? onPressed,
    bool isPortrait = false,
  }) {
    double height = 110;
    if (isPortrait) height = height * 3 + 40;

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
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          highlightColor: Colors.black.withOpacity(.1),
          splashColor: Colors.black.withOpacity(.1),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 20),
                if (child != null) child,
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
          _buildCard(
            context,
            title: '즐겨찾기',
            onPressed: () {
              Navigator.pushNamed(context, '/favorite');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('사용 가능'),
                    Text('8'),
                  ],
                ),
                SizedBox(width: 50),
                Column(
                  children: [
                    Text('사용 중'),
                    Text('6'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildCard(context, title: '제1열람실', onPressed: () {
            Navigator.pushNamed(context, '/room1');
          }),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  context,
                  title: '제2열람실',
                  isPortrait: true,
                  onPressed: () {
                    Navigator.pushNamed(context, '/room2');
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildCard(context, title: '노트북 열람실', onPressed: () {
                      Navigator.pushNamed(context, '/room', arguments: LaptopRoom());
                    }),
                    const SizedBox(height: 20),
                    _buildCard(context, title: '제5열람실', onPressed: () {
                      Navigator.pushNamed(context, '/room5');
                    }),
                    const SizedBox(height: 20),
                    _buildCard(context, title: 'SW 플라자', onPressed: () {
                      Navigator.pushNamed(context, '/roomsw');
                    }),
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
    List<String> titles = ['홈', '즐겨찾기', '프로필', '설정'];
    List<String> routes = ['/', '/favorite', '/profile', '/setting'];
    List<IconData> icons = [
      Icons.home,
      Icons.star,
      Icons.account_circle,
      Icons.settings,
    ];

    return ListTile(
      leading: Icon(icons[index], color: MyColorTheme.primary),
      title: Text(titles[index]),
      onTap: () {
        Navigator.pop(context);
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, routes[index], (route) => false);
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
            children: List.generate(4, (index) => _buildDrawerTile(context, index)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      )),
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
            const SizedBox(height: 30),
            Expanded(child: _buildCards(context)),
          ],
        ),
      ),
    );
  }
}