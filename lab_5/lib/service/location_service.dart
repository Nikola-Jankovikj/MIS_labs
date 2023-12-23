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

