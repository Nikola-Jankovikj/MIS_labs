import 'package:url_launcher/url_launcher.dart';

import '../Repository/location_repository.dart';

class MapUtils {

  MapUtils();

  static void openGoogleMaps(latitude, longitude) async {
    // Replace the latitude and longitude with your desired destination coordinates
    final double destinationLatitude = latitude;
    final double destinationLongitude = longitude;

    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';

    if (await canLaunch(googleMapsUrl) != null) {
      await launch(googleMapsUrl);
    } else {
      // Handle error, e.g., show an error dialog
      print('Could not launch Google Maps');
    }
  }
}