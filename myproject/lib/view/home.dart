import 'package:finalterm_project/model/product_repository.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'ASC';

  Widget _buildGridCards(BuildContext context) {
    final isAscending = dropdownValue != 'DESC';

    return Consumer<UserRepository>(builder: (context, user, child) {
      return Consumer<ProductRepository>(
        builder: (context, product, child) {
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 행에 두 개의 항목 표시
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: product.getSortedList(isAscending).map((p) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        AspectRatio(
                          aspectRatio: 18 / 11,
                          child: Image.network(
                            p.image!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (user.isInWishlist(p.id!))
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                        const SizedBox(height: 2.0),
                                        Text(
                                          '\$ ${p.price}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: p,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('more'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade600,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.person,
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
              Icons.shopping_cart,
              semanticLabel: 'cart',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
          ),
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
          const SizedBox(
            height: 30,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            items: <String>['ASC', 'DESC'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(
                  () {
                    dropdownValue = newValue;
                  },
                );
              }
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(child: _buildGridCards(context)),
        ],
      ),
    );
  }
}
