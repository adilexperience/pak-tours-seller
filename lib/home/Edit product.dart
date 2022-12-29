import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
class Edit_product extends StatefulWidget {
  const Edit_product({Key? key}) : super(key: key);

  @override
  _Edit_productState createState() => _Edit_productState();
}

class _Edit_productState extends State<Edit_product> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  ImagePicker imagePicker= ImagePicker();
  File? _imagefile;
  bool _loading =false;
  DocumentSnapshot? documentSnapshot;

  Future<void> _choose_image() async{
    // ignore: deprecated_member_use
    PickedFile? pickedFile= await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _imagefile = File(pickedFile!.path);
    });
  }




  void _validateupdate(){
    if(_imagefile==null && _descController.text.isEmpty && _nameController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add image and description');
    }else if(_imagefile==null){
      Fluttertoast.showToast(msg: 'please add image');
    }else if(_descController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add description');
    }else if(_nameController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add name');
    }

    else{
      setState(() {
        _loading=true;
      });
      _uploadupdateimage();

    }

  }



  void _uploadupdateimage(){
    String  _imagefilename = DateTime.now().microsecondsSinceEpoch.toString();
    final Reference storageReference = FirebaseStorage.instance.ref().child("Images").child(_imagefilename);
    final UploadTask uploadTask= storageReference.putFile(_imagefile!);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageurl) {

        updateToFirestore(imageurl);



      });

    }).catchError((onError){
      setState(() {
        _loading=false;
      });
      Fluttertoast.showToast(msg: onError.toString(),
      );
      print(onError.toString(),);

    });

  }

  updateToFirestore(String imageurl) async {
    final String name = _nameController.text;
    final String desc = _descController.text;
    final double? price =
    double.tryParse(_priceController.text);
    if (price != null) {
      await _products
          .doc(documentSnapshot!.id)
          .update({"name": name,
        "price": price,
        "Description":desc,
        'imageUrl': imageurl,

      });
      _nameController.text = '';
      _priceController.text = '';
      Navigator.of(context).pop();
    }

  }



  final CollectionReference _products = FirebaseFirestore.instance.collection('products');

  /*Future<void> _create([DocumentSnapshot? documentSnapshot]) async {

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
                _imagefile== null? Container(
                  width: double.infinity,
                  height: 250.0,
                  color: Colors.lightBlueAccent,
                  child: MaterialButton(
                    child: Text("Choose image",style: TextStyle(fontSize: 16.0),),
                    onPressed: () {
                      _choose_image();
                    },

                  ),
                ):GestureDetector(
                  onTap: (){
                    _choose_image();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_imagefile!),fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                SizedBox(height: 16.0,),
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
                  onPressed: () async {
                    _validate();
                  },
                )
              ],
            ),
          );

        });
  }*/
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _nameController.text = documentSnapshot['name'];
      _descController.text = documentSnapshot['Description'];
      _priceController.text = documentSnapshot['price'].toString();

    }

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
                _imagefile== null? Container(
                  width: double.infinity,
                  height: 250.0,
                  color: Colors.lightBlueAccent,
                  child: MaterialButton(
                    child: Text("Choose image",style: TextStyle(fontSize: 16.0),),
                    onPressed: () {
                      _choose_image();
                    },

                  ),
                ):GestureDetector(
                  onTap: (){
                    _choose_image();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(_imagefile!),fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
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
                  child: const Text( 'Update'),
                  onPressed: () async {
                    // _validateupdate();
                    final String name = _nameController.text;
                    final String desc = _descController.text;
                    final double? price =
                    double.tryParse(_priceController.text);
                    if (price != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"name": name,
                        "price": price,
                        "Description":desc,
                        // 'imageUrl': imageurl,

                      });
                      _nameController.text = '';
                      _priceController.text = '';
                      Navigator.of(context).pop();
                    }

                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Edit Product')),
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
                        backgroundImage: NetworkImage(documentSnapshot['imageUrl'].toString()),
                      ),
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['price'].toString()),
                     /* trailing: const Icon(Icons.arrow_forward),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Home_detail( DocumentSnapshot? documentSnapshot;)));
                      },*/
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _update(documentSnapshot)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _delete(documentSnapshot.id)),
                          ],
                        ),
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
// Add new product
        /*floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),

        ),*/
       /* floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat*/
    );
  }
}
