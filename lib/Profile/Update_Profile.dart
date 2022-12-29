import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class update_profile extends StatefulWidget {
  const update_profile({Key? key}) : super(key: key);

  @override
  _update_profileState createState() => _update_profileState();
}

class _update_profileState extends State<update_profile> {

  String? firstName;
  String? secondName;
  String? email;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();

  DocumentSnapshot? documentSnapshot;

  final CollectionReference _products = FirebaseFirestore.instance.collection('users');

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {

      _emailController.text = documentSnapshot['email'];
      _firstController.text = documentSnapshot['firstName'];
      _lastController.text = documentSnapshot['secondName'].toString();

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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _firstController,
                  decoration: const InputDecoration(labelText: 'First_Name'),
                ),
                TextField(
                  controller: _lastController,
                  decoration: const InputDecoration(
                    labelText: 'Last_Name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text( 'Update'),
                  onPressed: () async {
                    // _validateupdate();
                    final String email = _emailController.text;
                    final String fname = _firstController.text;
                    final String lname = _lastController.text;
                  //  final double? price = double.tryParse(_priceController.text);
                    if (email != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"email": email,
                        "firstName": fname,
                        "secondName":lname,
                        // 'imageUrl': imageurl,

                      });
                      _emailController.text = '';
                      _firstController.text = '';
                      _lastController.text = '';
                      Navigator.of(context).pop();
                    }

                  },
                )
              ],
            ),
          );
        });
  }


  Future _getprofiledata()async{
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async{
      if(snapshot.exists){
        setState(() {
          firstName=snapshot.data()!["firstName"];
          secondName=snapshot.data()!["secondName"];
          email=snapshot.data()!["email"];
        });
      }
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofiledata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Update Profile')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(

                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color:Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 2.0),
                  shadowColor: Colors.blue,


                  child: Column(
                    children: [
                      Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),

                        child: Row(

                          children: <Widget>[

                            Expanded(

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(



                                  children: <Widget>[

                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        color:  Colors.black87,
                                        fontSize: 17.0,


                                      ),

                                    ),

                                    SizedBox(

                                      height: 3.0,

                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                      child: Text(
                                        firstName!,
                                        style: TextStyle(

                                          fontSize: 17.0,

                                          color:  Colors.black87,

                                        ),

                                      ),
                                    )

                                  ],

                                ),
                              ),

                            ),


                          ],

                        ),

                      ),
                      Divider(),
                      Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),

                        child: Row(

                          children: <Widget>[

                            Expanded(

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(



                                  children: <Widget>[

                                    Text(

                                      "Last Name:",

                                      style: TextStyle(

                                        color:  Colors.black87,

                                        fontSize: 17.0,


                                      ),

                                    ),

                                    SizedBox(

                                      height: 3.0,

                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                      child: Text(

                                        secondName!,

                                        style: TextStyle(

                                          fontSize: 17.0,


                                        ),

                                      ),
                                    )

                                  ],

                                ),
                              ),

                            ),


                          ],

                        ),

                      ),
                      Divider(),
                      Padding(

                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),

                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: <Widget>[
                                    Text(

                                      "Email:",

                                      style: TextStyle(
                                        color:  Colors.black87,

                                        fontSize: 17.0,



                                      ),

                                    ),
                                    SizedBox(

                                      height: 3.0,

                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                      child: Text(
                                        email!,
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          color:  Colors.black87,

                                        ),

                                      ),
                                    )

                                  ],

                                ),
                              ),

                            ),


                          ],

                        ),

                      ),


                    ],
                  ),

                )
            ),
          ),
        ],
      ),
    );
  }
}
