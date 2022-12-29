import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tour_app_seller/Dashboard.dart';
import 'package:tour_app_seller/Models/uploaddata.dart';
class uploadpost extends StatefulWidget {
  const uploadpost({Key? key}) : super(key: key);

  @override
  _uploadpostState createState() => _uploadpostState();
}

class _uploadpostState extends State<uploadpost> {
  final _auth = FirebaseAuth.instance;
  final  TextEditingController _descriptionController = TextEditingController();
  final  TextEditingController _nameController = TextEditingController();
  final  TextEditingController _phoneController = TextEditingController();
  final  TextEditingController _addressController = TextEditingController();
  ImagePicker imagePicker= ImagePicker();

  File? _imagefile;
  bool _loading =false;

  Future<void> _choose_image() async{
    // ignore: deprecated_member_use
    PickedFile? pickedFile= await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
     _imagefile = File(pickedFile!.path);
    });
  }

  void _validate(){
    if(_imagefile==null && _descriptionController.text.isEmpty && _nameController.text.isEmpty
        && _addressController.text.isEmpty && _phoneController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add image and description');
    }else if(_imagefile==null){
      Fluttertoast.showToast(msg: 'please add image');
    }else if(_descriptionController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add description');
    }else if(_nameController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add name');
    }else if(_addressController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add Address');
    }else if(_phoneController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please add Phone Number');
    }
    else{
      setState(() {
        _loading=true;
      });
      _uploadimage();

    }

  }

  void _uploadimage(){

    String  _imagefilename = DateTime.now().microsecondsSinceEpoch.toString();
    final Reference storageReference = FirebaseStorage.instance.ref().child("Images").child(_imagefilename);
    final UploadTask uploadTask= storageReference.putFile(_imagefile!);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageurl) {

        postDetailsToFirestore(imageurl);

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

/*
  void _savedata( String imageurl){
    var dateFormat = DateFormat("MMM d,yyyy");
    var timeFormat = DateFormat("EEEE ,hh:mm a");

    String date= dateFormat.format(DateTime.now()).toString();
    String time= timeFormat.format(DateTime.now()).toString();
    final FirebaseAuth _auth = FirebaseAuth.instance;



  FirebaseFirestore.instance.collection("Sellerposts")
      .add({
    'imageUrl': imageurl,
    'description':_descriptionController.text,
    'name':_nameController.text,
    'address':_addressController.text,
    'phone':_phoneController.text,
    'Date':date,
    'Time':time,


  }).whenComplete(() {
    setState(() {
      _loading=false;
    });
    Fluttertoast.showToast(msg: "Post Add Succesfuly"
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
      return Dashboard();

    }));
  }).catchError((onError){
    setState(() {
      _loading=false;
    });
    Fluttertoast.showToast(msg: onError.toString(),

    );
    print(onError.toString(),);
    });

  }*/


  postDetailsToFirestore(String imageurl) async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UploadModel uploadModel = UploadModel();

    // writing all the values

    uploadModel.uid = user!.uid;
    uploadModel.description=_descriptionController.text;
    uploadModel.name=_nameController.text;
    uploadModel.address=_addressController.text;
    uploadModel.phone=_phoneController.text;
    uploadModel.image=imageurl;
    await firebaseFirestore
        .collection("Sellerposts")
        .doc(user.uid)
        .set(uploadModel.toMap());
    Fluttertoast.showToast(msg: " Product Upload successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('uploadscreen'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Phone No',
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                ),
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Description',
                  ),
                ),
              ),

              SizedBox(height: 16.0,),

               Material(
                 elevation:  5,
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.blue,
                 child: MaterialButton(
                   minWidth: MediaQuery.of(context).size.width,
                  // style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                   onPressed: () async {
                     _validate();
                     setState(() {
                       _loading = false;
                     });
                   },
                   child: (_loading)
                       ? const SizedBox(
                       width: 16,
                       height: 16,
                       child: CircularProgressIndicator(
                         color: Colors.red,
                         strokeWidth: 1.5,
                       ))
                       : const Text('Submit', style: TextStyle(
                       fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                 ),
                 /*child: MaterialButton(

                   child: Center(
                     child: Text("Upload Post", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                   ),
                  color: Colors.blue,
                  onPressed:  _validate,

              ),*/
               ),
            ],
          ),
        ),
      ),
    );
  }
}





