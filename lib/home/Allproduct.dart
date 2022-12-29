import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tour_app_seller/Models/post.dart';
import 'package:tour_app_seller/home/Edit%20product.dart';
import 'package:tour_app_seller/home/home_detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DocumentSnapshot? documentSnapshot;

  final CollectionReference _products = FirebaseFirestore.instance.collection('products');



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('All Product')),
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  return Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.all(12),

                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(documentSnapshot['imageUrl'].toString()),),
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['price'].toString()),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home_detail(
                                name: documentSnapshot["name"],
                                price: documentSnapshot["price"].toString(),
                                description: documentSnapshot["Description"],
                                image: documentSnapshot["imageUrl"].toString(),)),
                        );
                      },

                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }
}




