import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vetconnect/constants.dart';

// this will be the map page that shows the businesses near the user.

class BusinessHome extends StatefulWidget {
  const BusinessHome({super.key});

  @override
  State<BusinessHome> createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  LatLng? _coords;
  Marker? _marker;

  @override 
  void initState() async {
    super.initState();

    if (Constants.locationManager.serviceEnabled && Constants.locationManager.locationPermission){
      final position = await Constants.locationManager.location();
      _coords = LatLng(position.latitude, position.longitude);
      _marker = _createMarker(_coords);
    }
  }
    
  Marker _createMarker(LatLng? coords) {
    return Marker(
      point: coords!,
      width: 40,
      height: 40,
      child: Icon(
        Icons.location_on,
        color: Color.fromARGB(255, 255, 255, 1),
        size: 36,
      ),
    );
  }

  Widget _mapDisplay(LatLng? coords, Marker? marker) {
    // TODO: add some sort of note saying location permission is not enabled if serviceEnabled or locationPermission not enabled
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: (coords != null) ? coords! : LatLng(0, 0),
            initialZoom: 15,
          ),
          children: [
              TileLayer(
                urlTemplate:
                    "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png?api_key=4f8befcc-ea6d-4043-bfec-bea5b96a2c70",
                userAgentPackageName: 'vetconnect',
              ),
            MarkerLayer(markers: (marker != null) ? [marker!] : []),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _mapDisplay(_coords, _marker)        
        ]
      ) 
    );
  }
}
