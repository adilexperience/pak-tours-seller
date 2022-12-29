import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_seller/Profile/Update_Profile.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);



  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  String? firstName;
  String? secondName;
  String? email;

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
        backgroundColor:Colors.blue,
       /* actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Edit Profile",
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => update_profile()));
            },
          )
        ],*/
      ),
      body: Column(

        children: <Widget>[
          Container(

            child: Card(
                   shape: OutlineInputBorder(
                   borderSide: BorderSide(color: Colors.blue, width: 1),
                   borderRadius: BorderRadius.circular(30),

                   ),
                color: Colors.blue,

              child: Container(
                width: double.infinity,
                height: 200.0,

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                        ),
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              )
          ),
          ),
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
                                child: Row(



                                  children: <Widget>[

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
