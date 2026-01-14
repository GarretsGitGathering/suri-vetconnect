import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationManager {
  bool _serviceEnabled = false;
  bool _locationPermission = false;

  bool get serviceEnabled => _serviceEnabled;
  bool get locationPermission => _locationPermission;
  Future<Position> Function() get location => () async {
    return await Geolocator.getCurrentPosition();
  };

  LocationManager._(this._serviceEnabled, this._locationPermission);

  static Future<LocationManager> init() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){ print("Location Service not enabled."); }

    // check if permission is enabled; request if not enabled
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission has been denied."); 
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission is denied forever.");
    }

    return LocationManager._(serviceEnabled, (permission != LocationPermission.denied && permission != LocationPermission.deniedForever));
  }


}
