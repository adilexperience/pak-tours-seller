import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_app_seller/home/Allproduct.dart';
import 'package:tour_app_seller/login.dart';
import 'package:get/get.dart';
import 'package:tour_app_seller/pproduct/Addproduct.dart';
import 'package:tour_app_seller/uploadpost.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: Colors.blue,
        title: Text(
            "Home Page"
        ),
      ),
      drawer: Container(
        width: 230,
        child: Drawer(
          child: ListView(
            // Remove padding

            children: [
              UserAccountsDrawerHeader(
                accountName: Text('',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),),
                accountEmail: Text('',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),),

                decoration: BoxDecoration(
                  color:Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",)),
                ),
              ),
              ListTile(
                //    leading: Icon(Icons.person),
                title: Text('My Profile'),
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>profile()));
                },
              ),
              ListTile(
                //    leading: Icon(Icons.contact_phone_rounded),
                title: Text('All Product'),
                onTap: () =>null,
              ),
              Divider(),
              ListTile(
                //    leading: Icon(Icons.policy),
                title: Text('Edit Product'),
              ),
              ListTile(
                //     leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () => null,
              ),
              ListTile(
                //     leading: Icon(Icons.rate_review),
                title: Text('Rate Us'),
                onTap: () => null,
              ),
              Divider(),
              ListTile(
                  title: Text('Log Out'),
                  //   leading: Icon(Icons.exit_to_app),
                  onTap: ()async{
                    logout(context);
                    final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.remove('email');
                    Get.to(Login_Screen());
                  }),

            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>
        [Column(
            children: [
              Container(
                  height: 300,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(child: Lottie.asset('assets/images/tour.json'),),
                  )
                /*child: Container(
                 margin: EdgeInsets.fromLTRB(20,20,20,40),
                 decoration: BoxDecoration(
                   color: Colors.black12,
                   borderRadius: BorderRadius.only(
                     topRight: Radius.circular(36),
                     bottomLeft: Radius.circular(10),
                     bottomRight: Radius.circular(10),
                     topLeft: Radius.circular(10)


                   ),
                 ), ),*/
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 270,
                    width: 10,
                  ),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .95,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue,width: 1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            /*boxShadow: [
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 3,
                                offset: Offset(4, 8), // Shadow position
                              ),
                            ],*/


                          ),

                          child: MaterialButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/addimage.png"),
                                  Spacer(),
                                  Text("Upload Post",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),

                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue,width: 1),

                          ),
                          child: MaterialButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/imagefiles.png"),
                                  Spacer(),
                                  Text("All Posts",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue,width: 1),

                          ),
                          child: MaterialButton(onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Notice()));
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/rating.png"),
                                  Spacer(),
                                  Text("Rate Us",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue,width: 1),

                          ),
                          child: MaterialButton(onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>class_detail()));
                          },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/sharing.png"),
                                  Spacer(),
                                  Text("Share",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),),

                                ],
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login_Screen()));
  }
}
