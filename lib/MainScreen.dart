import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_seller/Dashboard.dart';
import 'package:tour_app_seller/Profile/profile.dart';
import 'package:tour_app_seller/home/Edit%20product.dart';
import 'package:tour_app_seller/home/Allproduct.dart';
import 'package:tour_app_seller/login.dart';
import 'package:tour_app_seller/notification.dart';
import 'package:tour_app_seller/pproduct/Addproduct.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    AddProduct(),
    Edit_product(),
    NotificationDialog(),
    profile(),

  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final space = const SizedBox(
    height: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(color: Colors.blue),
        selectedIconTheme: const IconThemeData(color: Colors.blue),
        backgroundColor: Colors.grey[200],
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.map,
              color: Colors.blue,
            ),
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            activeIcon: Icon(
              Icons.satellite_sharp,
              color: Colors.blue,
            ),
            icon: Icon(Icons.home_outlined),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            activeIcon: Icon(
              Icons.trip_origin,
              color: Colors.blue,
            ),
            icon: Icon(
              Icons.trip_origin_outlined,
            ),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            activeIcon: Icon(
              Icons.inbox,
              color: Colors.blue,
            ),
            icon: Icon(
              Icons.inbox_outlined,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            activeIcon: Icon(
              Icons.menu_book,
              color: Colors.blue,
            ),
            icon: Icon(
              Icons.menu_book_outlined,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }



  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login_Screen()));
  }
}
