import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_seller/Models/user_model.dart';
import 'package:tour_app_seller/login.dart';
import 'package:tour_app_seller/utils/api_requests/api_requests.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  UserModel? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
      body: user == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
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
                                backgroundImage: NetworkImage(user!.imageUrl),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                      child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                    shadowColor: Colors.blue,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Name",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 0, 0),
                                        child: Text(
                                          user!.name,
                                          style: const TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black87,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Email address:",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            30,
                                            0,
                                            0,
                                            0,
                                          ),
                                          child: Text(
                                            user!.emailAddress,
                                            style: const TextStyle(
                                              fontSize: 17.0,
                                            ),
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
                        const Divider(),
                        ElevatedButton(
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login_Screen(),
                                ),
                                (route) => false);
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            ),
    );
  }

  void getProfileData() async {
    user = await ApiRequests.getLoggedInUser();
    setState(() {});
  }
}
