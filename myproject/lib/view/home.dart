import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new

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

  Widget _firstlistBuild(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context,
                '/${entries[index]}'); // change the route name accordingly
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.amber[colorCodes[index %
                  3]], // colorCodes index is calculated as modulus of 3 to prevent out of range error
              borderRadius: BorderRadius.circular(10.0), // Add this
            ), // colorCodes index is calculated as modulus of 3 to prevent out of range error
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${entries[index]}'),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 30),
    );
  }

  Widget _secondlistBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 20.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/제2열람실');
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  // add this
                  borderRadius: BorderRadius.circular(
                      10.0), // change this to adjust the radius
                ),
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    borderRadius: BorderRadius.circular(
                        10.0), // change this to adjust the radius
                  ),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('제2열람실'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [     
                _buildListItem(context, '노트북 열람실', Colors.amber),
                const SizedBox(
                  height: 10,
                ),
                _buildListItem(context, '제5열람실', Colors.amber),
                const SizedBox(
                  height: 10,
                ),
                _buildListItem(context, 'SW 플라자', Colors.amber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/$title');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          // add this
          borderRadius:
              BorderRadius.circular(10.0), // change this to adjust the radius
        ),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(10.0), // change this to adjust the radius
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle_rounded,
            semanticLabel: 'profile',
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'plus',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 0, 0), // 여기서 상단 패딩 크기 조절 가능
            child: Align(
              alignment: Alignment.topLeft, // 좌측 정렬
              child: RichText(
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
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(child: _firstlistBuild(context)),
          Expanded(child: _secondlistBuild(context)),
        ],
      ),
    );
  }
}
