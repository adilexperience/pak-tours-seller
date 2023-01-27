import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_app_seller/utils/app_colors.dart';
import 'package:tour_app_seller/widgets/primary_button.dart';

class Constants {
  // firebase constants
  static const String placesCollection = "Places";
  static const String notificationsCollection = "Notifications";
  static const String wishListsCollection = "Wishlists";
  static const String ordersCollection = "Orders";
  static const String usersCollection = "Users";
  static const String productsCollection = "Products";
  static const String reviewsCollection = "Reviews";

  static const String profilePictures = "ProfilePictures";

  // persistent constants
  static const String persistentLoggedUser = "PersistentLoggedUser";

  static String applicationName = "ThePakTours Seller";

  static int nearbyPlacesDistanceInKilometers = 100;
  static int nearbySellerDistanceInKilometers = 20;
  static double mapDefaultZoom = 15.0746;

  static void pushNamed(BuildContext context, String destination) {
    Navigator.of(context).pushNamed(destination);
  }

  static void pushNamedAndRemoveAll(BuildContext context, String destination) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      destination,
      (route) => false,
    );
  }

  static void pushAndRemoveAll(BuildContext context, Widget destination) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  static push(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static bool isEmailValid(String email) {
    return email.isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  static bool isPasswordValidated(String password) {
    return password.isNotEmpty && password.length >= 8;
  }

  static showTwoButtonDialog({
    required BuildContext context,
    String? dialogMessage,
    Widget? child,
    bool isDismissible = true,
    String primaryButtonText = "Accept",
    String secondaryButtonText = "Decline",
    VoidCallback? onPressed,
    VoidCallback? secondaryOnPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AlertDialog(
        title: Text(
          Constants.applicationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: child ?? Text(dialogMessage!),
        actions: <Widget>[
          InkWell(
            onTap: secondaryOnPressed ?? () => Navigator.pop(context),
            child: Text(
              secondaryButtonText,
              style: const TextStyle(
                color: AppColors.strongText,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8.0),
          PrimaryButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            buttonText: primaryButtonText,
            fontSize: 14.0,
          ),
        ],
      ),
    );
  }

  static double getDistance(LatLng currentLocation, LatLng destinationLocation,
      {bool responseInKilometer = true}) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destinationLocation.latitude,
      destinationLocation.longitude,
    );
    double distanceInKilometers = distanceInMeters / 1000;
    if (responseInKilometer) {
      return distanceInKilometers;
    } else {
      return distanceInMeters;
    }
  }

  static showTwoPrimaryButtonDialog({
    required BuildContext context,
    required String dialogMessage,
    required String firstPrimaryButtonText,
    VoidCallback? firstPrimaryButtonOnPressed,
    required String secondPrimaryButtonText,
    VoidCallback? secondPrimaryButtonOnPressed,
    bool customFirstButton = false,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(applicationName),
        content: Text(dialogMessage),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: customFirstButton
                      ? PrimaryButton(
                          onPressed: firstPrimaryButtonOnPressed,
                          buttonText: firstPrimaryButtonText,
                        )
                      : InkWell(
                          onTap: firstPrimaryButtonOnPressed,
                          child: Text(
                            firstPrimaryButtonText,
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: PrimaryButton(
                    onPressed: secondPrimaryButtonOnPressed,
                    buttonText: secondPrimaryButtonText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> askLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if ((permission == LocationPermission.denied) ||
        (permission == LocationPermission.deniedForever)) {
      LocationPermission requestPermission =
          await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied) {
        showTwoPrimaryButtonDialog(
          context: context,
          dialogMessage:
              "Please grant location permission to $applicationName. we need to track your latitude and longitude to assign place to your selling zone.",
          firstPrimaryButtonText: 'Not Now',
          secondPrimaryButtonText: 'Grant Permission',
          secondPrimaryButtonOnPressed: () {
            Navigator.pop(context);
            askLocationPermission(context);
          },
        );
      } else if (requestPermission == LocationPermission.deniedForever) {
        showTwoPrimaryButtonDialog(
          context: context,
          dialogMessage:
              "Please grant location permission to $applicationName by manually going to device settings.\nwe need to track your latitude and longitude to assign you selling zone.",
          firstPrimaryButtonText: "Not Now",
          secondPrimaryButtonText: "Grant Permission",
          secondPrimaryButtonOnPressed: () {
            Navigator.pop(context);
            Geolocator.openLocationSettings();
          },
        );
      }
      return false;
    } else {
      return true;
    }
  }
}
