import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_seller/Models/product_model.dart';
import 'package:tour_app_seller/home/home_detail.dart';
import 'package:tour_app_seller/utils/api_requests/api_requests.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DocumentSnapshot? documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('All Product')),
      ),
      body: StreamBuilder(
        stream: ApiRequests.getStreamOfProducts(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot productDocument =
                    streamSnapshot.data!.docs[index];
                ProductModel product = ProductModel.fromJson(
                    productDocument.data() as Map<String, dynamic>);
                return Card(
                  elevation: 10.0,
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.image),
                    ),
                    title: Text(product.title),
                    subtitle: Text(product.price),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home_detail(
                            name: product.title,
                            price: product.price,
                            description: product.description,
                            image: product.image,
                          ),
                        ),
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
