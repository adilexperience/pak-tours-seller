import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_app_seller/Dashboard.dart';
import 'package:tour_app_seller/MainScreen.dart';
import 'package:tour_app_seller/signup.dart';

String? email;

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final _keyform = GlobalKey<FormState>();


  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();
    final _auth = FirebaseAuth.instance;
  bool _loading =false;
  String? errorMessage;



  @override
  Widget build(BuildContext context) {
    final UserEmail = TextFormField(
        autofocus: false,
        controller: email,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'please enter your email address';
          }

          return null;
        },
        onSaved: (value) {
          email.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final UserPassword = TextFormField(

      autofocus: true,
      controller: password,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){

          return 'Please Enter Your password';
        }
        },
      onSaved: (value)
      {
        password.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),


    );
    final Login_Button = Material(
      elevation:  5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        // style: ElevatedButton.styleFrom(shape: StadiumBorder()),
        onPressed: () async {
          Login_Function(email.text, password.text);
          setState(() {
            _loading = true;
          });
          final  SharedPreferences  sharedPreferences =  await SharedPreferences.getInstance();
          sharedPreferences.setString('email', email.text);
        },
        child: (_loading)
            ? const SizedBox(
            width: 16,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ))
            : const Text('Login', style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
      ),


    );
    final Signup_Button = Material(
      elevation:  5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {

            Get.to(RegistrationScreen());

        },
        child:  Text(
          "Create New Account ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),


      ),


    );

    return Scaffold(
      backgroundColor:  Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,

            child: Form(
            key: _keyform,

              child: Padding(
               padding: const EdgeInsets.all(25.0),
               child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(30.0),
                 child: SizedBox(

                          height: 200,
                   child: Lottie.asset('assets/images/tour.json'),),
               ),

                 UserEmail ,
                 SizedBox(height: 20,),

                 UserPassword,
                 SizedBox(height: 20,),

                 Login_Button,
                 SizedBox(height: 20,),

                 Signup_Button,
                 SizedBox(height: 20,)






               ],
             ),
           ),

         ),
          ),
        ),
      ),
    );





  }


  void Login_Function(String  email , String password)  async   {

    if  (_keyform.currentState!.validate()){

      try {

        await _auth.signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
          Fluttertoast.showToast(msg: "Login Successfully"),
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainScreen()), (route) => false),
        }

        );



 }on FirebaseAuthException catch (error) {
        switch (error.code) {
           case "invalid-email":
             errorMessage = "Your email address appears to be malformed.";

           break;
          case "wrong-password":
           errorMessage = "Your password is wrong.";
           break;
          case "user-not-found":
           errorMessage = "User with this email doesn't exist.";
             break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
             break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
        case "operation-not-allowed":
             errorMessage = "Signing in with Email and Password is not enabled.";
             break;
         default:
             errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
         print(error.code);
      }

    }

  }

}




