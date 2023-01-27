import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_app_seller/Models/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
// text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  bool _loading = false;
  DocumentSnapshot? documentSnapshot;

  Future<void> _choose_image() async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _imagefile = File(pickedFile!.path);
    });
  }

  void _validate() {
    if (_nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please provide product title');
    } else if (_imagefile == null) {
      Fluttertoast.showToast(msg: 'please add image');
    } else if (_descController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please add description');
    } else if (_priceController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'please add price');
    } else {
      _uploadupdateimage();
    }
  }

  Future<void> postDetailsToFirestore(String id, String imageurl) async {
    final String name = _nameController.text;
    final String desc = _descController.text;
    final String price = _priceController.text;

    ProductModel productModel = ProductModel(
      id: id,
      title: name,
      image: imageurl,
      description: desc,
      price: price,
      seller: FirebaseAuth.instance.currentUser!.uid,
      isAllowed: true,
      publishedAt: Timestamp.now(),
    );

    await FirebaseFirestore.instance
        .collection("Products")
        .doc(id)
        .set(productModel.toJson());

    _nameController.text = '';
    _descController.text = '';
    _priceController.text = '';
    _imagefile = null;

    setLoading(false);
    Navigator.of(context).pop();
  }

  void setLoading(bool loading) {
    _loading = loading;
    setState(() {});
  }

  void _uploadupdateimage() {
    setLoading(true);

    DocumentReference productReference =
        FirebaseFirestore.instance.collection("Products").doc();

    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("Products")
        .child(productReference.id);
    final UploadTask uploadTask = storageReference.putFile(_imagefile!);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageurl) async {
        await postDetailsToFirestore(productReference.id, imageurl);
      });
    }).catchError((onError) {
      setLoading(false);
      Fluttertoast.showToast(
        msg: onError.toString(),
      );
    });
  }

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagefile == null
                    ? Container(
                        width: double.infinity,
                        height: 250.0,
                        color: Colors.lightBlueAccent,
                        child: MaterialButton(
                          child: const Text(
                            "Choose image",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            _choose_image();
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _choose_image();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 250.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_imagefile!),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () => _validate(),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Add New Product')),
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
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          documentSnapshot['imageUrl'].toString(),
                        ),
                      ),
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(
                        documentSnapshot['price'].toString(),
                      ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
