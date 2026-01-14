import 'package:flutter/material.dart';
import 'package:vetconnect/business/business_handler.dart';
import 'package:vetconnect/constants.dart';
import 'package:vetconnect/route_page.dart';
import 'package:vetconnect/services/location_manager.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void initState() async {
    super.initState();

    BusinessHandler? businessHandler = await BusinessHandler.init();
    if (businessHandler != null) {
      Constants.businessHandler = businessHandler;
    } else {
      print("Unable to initialize business handler.");
    }

    Constants.locationManager = await LocationManager.init();
    if (!Constants.locationManager.serviceEnabled) {
      Constants.showPopup(context, "Location Service Disabled", "The location services on this device have been disabled. Please go into settings and enable them for the app to fully function.");
    }
    if (!Constants.locationManager.locationPermission) {
      Constants.showPopup(context, "Location Permission Disabled", "Location permissions for this app have been disabled. Please go into settings and enabled them for the app to full funciton.");
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RoutePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: make a loading page
    );
  }
}
