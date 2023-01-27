import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tour_app_seller/Models/place_model.dart';
import 'package:tour_app_seller/Models/product_model.dart';
import 'package:tour_app_seller/Models/user_model.dart';
import 'package:tour_app_seller/login.dart';
import 'package:tour_app_seller/utils/constants.dart';

class ApiRequests {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static bool get isLoggedIn =>
      (_firebaseAuth.currentUser == null) ? false : true;

  static Future<UserModel> getLoggedInUser() async {
    UserModel? _user;
    await _firebaseFirestore
        .collection("Users")
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((user) {
      _user = UserModel.fromJson(user.data() as Map<String, dynamic>);
    });
    return _user!;
  }

  static Future<void> updateUsername(String username) async {
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(username);
      await _firebaseFirestore
          .collection(Constants.usersCollection)
          .doc(_firebaseAuth.currentUser?.uid)
          .update({
        "name": username,
      });
    } on Exception catch (e) {
      rethrow;
    }
  }

  static Future<void> login(String email, String password,
      {required BuildContext context}) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      return true;
    }).onError((error, stackTrace) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: error.toString(),
        ),
      );
      return false;
    });
  }

  static Future<void> getRecoveryPasswordLink(String email,
      {required BuildContext context}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: "Instructions shared on your associated email address",
        ),
      );
      return true;
    }).onError((error, stackTrace) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: error.toString()),
      );
      return false;
    });
  }

  static Future<void> registerSeller(String username, String email, String uid,
      double latitude, double longitude,
      {required BuildContext context}) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: uid)
        .then((value) async {
      await storeRecord(
        value.user!.uid,
        username,
        email,
        uid,
        latitude,
        longitude,
        context: context,
      );
      await sendEmailVerificationLink();
    }).onError((error, stackTrace) {
      throw (error!);
    });
  }

  static Future<void> storeRecord(String id, String username, String email,
      String uid, double latitude, double longitude,
      {required BuildContext context}) async {
    DocumentReference usersReference =
        _firebaseFirestore.collection(Constants.usersCollection).doc(id);
    UserModel user = UserModel(
      id: id,
      name: username,
      emailAddress: email,
      roles: ["seller"],
      joinedAt: Timestamp.now(),
      isAllowed: false,
      location: GeoPoint(latitude, longitude),
      imageUrl: "",
    );
    await usersReference.set(user.toJson());
  }

  static Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Constants.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location services are disabled. Grant location permissions for this app to function properly, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Constants.showTwoButtonDialog(
          context: context,
          dialogMessage:
              "Grant location permissions for this app to function properly, otherwise app will not function properly",
          primaryButtonText: "Okay",
          onPressed: () => Geolocator.openLocationSettings(),
          secondaryButtonText: "Not now",
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Constants.showTwoButtonDialog(
        context: context,
        dialogMessage:
            "Location permissions are permanently denied, we cannot request permissions. grant permission from settings, otherwise app will not function properly",
        primaryButtonText: "Okay",
        onPressed: () => Geolocator.openLocationSettings(),
        secondaryButtonText: "Not now",
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<PlaceModel>> getAllPlaces() async {
    List<PlaceModel> places = [];
    await _firebaseFirestore
        .collection(Constants.placesCollection)
        .get()
        .then((value) {
      for (var element in value.docs) {
        places.add(PlaceModel.fromJson(element.data()));
      }
    });
    return places;
  }

  static Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];
    await _firebaseFirestore
        .collectionGroup(Constants.productsCollection)
        .get()
        .then((value) {
      for (var element in value.docs) {
        products.add(
          ProductModel.fromJson(
            element.data(),
          ),
        );
      }
    });
    return products;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> isPlaceAlreadyLiked(
      String placeID) {
    return _firebaseFirestore
        .collectionGroup(Constants.wishListsCollection)
        .where("user_id", isEqualTo: _firebaseAuth.currentUser?.uid)
        .where("place_id", isEqualTo: placeID)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getStreamOfNotifications() {
    return _firebaseFirestore
        .collection(Constants.notificationsCollection)
        .where("user_id", isEqualTo: _firebaseAuth.currentUser?.uid)
        .orderBy("sent_at", descending: true)
        .snapshots();
  }

  static Future<PlaceModel> getPlaceByID(String placeID) async {
    PlaceModel? place;
    await _firebaseFirestore
        .collection(Constants.placesCollection)
        .where("id", isEqualTo: placeID)
        .get()
        .then((_places) {
      PlaceModel _place = PlaceModel.fromJson(_places.docs.first.data());
      place = _place;
    });
    return place!;
  }

  static Future<String> uploadSelectedImage(File _image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(Constants.usersCollection)
        .child(Constants.profilePictures)
        .child(_firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(_image);
    String imageURL = "";
    await uploadTask.then((value) async {
      imageURL = await value.ref.getDownloadURL();
    });
    return imageURL;
  }

  static updateProfileImageURL(String url) async {
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .doc(_firebaseAuth.currentUser?.uid)
        .update({"image_url": url});
    return;
  }

  static Future<List<ProductModel>> getProductsOfSeller(String sellerID) async {
    List<ProductModel> products = [];
    await _firebaseFirestore
        .collection(Constants.productsCollection)
        .where("seller", isEqualTo: sellerID)
        .where("is_allowed", isEqualTo: true)
        .orderBy("published_at", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        products.add(ProductModel.fromJson(element.data()));
      }
    });
    return products;
  }

  static Future<UserModel> getUserById(String userId) async {
    late UserModel user;
    await _firebaseFirestore
        .collection(Constants.usersCollection)
        .where("id", isEqualTo: userId)
        .orderBy("joined_at", descending: true)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.docs.first.data());
    });
    return user;
  }

  static Future<void> updatePlaceRating(
      double finalRating, String placeID) async {
    await _firebaseFirestore
        .collection(Constants.placesCollection)
        .doc(placeID)
        .update({"rating": finalRating});
    return;
  }

  static void signOut(BuildContext context) {
    _firebaseAuth.signOut();
    Constants.pushAndRemoveAll(
      context,
      const Login_Screen(),
    );
  }

  static bool checkEmailVerificationStatus() {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  static Future<void> sendEmailVerificationLink() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  static Future<bool> checkIfNotSeller() async {
    UserModel user = await getLoggedInUser();
    if (user.roles.contains("seller")) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> isSellerAllowed() async {
    UserModel user = await getLoggedInUser();
    return user.isAllowed;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getStreamOfProducts() {
    return _firebaseFirestore
        .collection(Constants.productsCollection)
        .where("seller", isEqualTo: _firebaseAuth.currentUser?.uid)
        .snapshots();
  }
}
