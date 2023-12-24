import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lab_3/Repository/location_repository.dart';
import 'package:lab_3/service/notification_service.dart';
import 'package:lab_3/utils/google_maps_utils.dart';
import 'package:latlong2/latlong.dart';
import '../model/Location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Map'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(41.9981, 21.4254),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  LocationRepository().finki.latitude,
                  LocationRepository().finki.longitude,
                ),
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    // Show the alert dialog here
                    _showAlertDialog();
                  },
                  child: const Icon(Icons.pin_drop),
                ),
              )
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show the alert dialog
  Future<void> _showAlertDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open Google Maps?'),
          content: Text('Do you want to open Google Maps for routing?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                MapUtils.openGoogleMaps(LocationRepository().finki.latitude, LocationRepository().finki.longitude); // Open Google Maps using url_launcher
                Navigator.of(context).pop();
              },
              child: Text('Open'),
            ),
          ],
        );
      },
    );
  }
}