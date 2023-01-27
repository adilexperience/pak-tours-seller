import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_seller/MainScreen.dart';

import 'login.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => FirebaseAuth.instance.currentUser == null
                  ? const Login_Screen()
                  : const MainScreen()),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/baltit_fort.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.4),
          ])),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Pak Tourism",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Let's start Tour.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
//
// import 'package:ecommernce_app/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: Splash(),
//   ));
// }
//
// class Splash extends StatefulWidget {
//   const Splash({Key? key}) : super(key: key);
//
//   @override
//   _SplashState createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     Timer(Duration(seconds: 20),(){
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/images/shopping.jpg")
//         )
//       ),
//
//       child: Center(
//         child: Text("Shopping App",style: TextStyle(color: Colors.black,fontSize: 20),),
//       ),
//
//
//
//
//     );
//   }
// }
//
//
//

// import 'dart:async';
//
// import 'package:ecommernce_app/main.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: Splash_Screen(),
//
//   ));
// }
//
// class Splash_Screen extends StatefulWidget {
//   const Splash_Screen({Key? key}) : super(key: key);
//
//   @override
//   _Splash_ScreenState createState() => _Splash_ScreenState();
// }
//
// class _Splash_ScreenState extends State<Splash_Screen> {
//   @override
//   void initState() {
//     Timer(Duration(seconds: 10),(){
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.deepOrange,
//       child: Center(child: Text("Hello",style: TextStyle(),),),
//     );
//   }
// }
