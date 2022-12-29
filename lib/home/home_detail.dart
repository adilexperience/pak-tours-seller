import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tour_app_seller/Models/post.dart';
class Home_detail extends StatelessWidget {
   String? name;

   Home_detail({this.name, this.description, this.price, this.image});

  String? description;
   String? price;
   String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all( 16.0),
            elevation: 12.0,
            child: Container(
              padding: EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0,),
                  Image.network(image.toString(),width: double.infinity,height: 300.0,fit: BoxFit.cover,),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Text("Product Name:",
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(fontSize: 18.0,color: Colors.black),),
                      SizedBox(width: 10.0,),

                      Text(name.toString(),
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(fontSize: 15.0,color: Colors.black),),

                    ],
                  ),

                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Text("Product Price:",
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(fontSize: 18.0,color: Colors.black),),
                      SizedBox(width: 10.0,),
                      Text(price.toString(),
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(fontSize: 15.0,color: Colors.blue),),

                    ],
                  ),

                  SizedBox(height: 10.0,),

                  Column(
                    children: [
                      Text("Product Description:",
                        style:
                        const TextStyle(fontSize: 18.0,color: Colors.black),),
                      SizedBox(height: 10.0,),
                       ReadMoreText(
                         description.toString(),
                          trimLines: 1,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                       trimCollapsedText: 'Show more',
                       trimExpandedText: 'Show less',
                       moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
