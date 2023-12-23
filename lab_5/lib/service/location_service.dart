// import 'package:location/location.dart';
//
// class LocationService {
//   Location location = Location();
//
//   Future<bool> requestPermission() async {
//     final permission = await location.requestPermission();
//     return permission == PermissionStatus.granted;
//   }
//
//   Future<LocationData> getCurrentLocation() async {
//     final serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       final result = await location.requestService;
//       if (result == true) {
//         print('Service has been enabled');
//       } else {
//         throw Exception('GPS service not enabled');
//       }
//     }
//
//     final locationData = await location.getLocation();
//     return locationData;
//   }
// }

import 'package:geolocator/geolocator.dart';

class LocationService{
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle denied permission permanently
    } else {
      // Permission granted
    }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}

