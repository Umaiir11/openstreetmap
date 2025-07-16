// File: map_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'location_model.dart';

class MapControllerX extends GetxController {
  final MapController mapController = MapController();
  final Rx<LatLng> currentLocation = LatLng(0.0, 0.0).obs;
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final RxList<LocationModel> searchResults = <LocationModel>[].obs;
  final Rx<LatLng?> pinDropLocation = Rx<LatLng?>(null);

  void dropPinAt(LatLng location) {
    pinDropLocation.value = location;
  }

  void clearDroppedPin() {
    pinDropLocation.value = null;
    selectedLocation.value = null;
    Get.snackbar(
      '📍 Pin Removed',
      'Dropped pin has been cleared from map.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      icon: const Icon(Icons.location_off_rounded, color: Colors.redAccent),
      duration: const Duration(seconds: 2),
    );
  }


  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final position = await _determinePosition();
      if (position != null) {
        final latLng = LatLng(position.latitude, position.longitude);
        currentLocation(latLng);
        _moveTo(latLng, 15.0);
      }
    } catch (e) {



      Get.snackbar('Location Error', 'Failed to get current location');
    }
  }

  Future<Position?> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return null;
    }


    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void updateSelectedLocation(LatLng location) {
    selectedLocation(location);
    _moveTo(location, 16.0);
  }

  Future<void> searchLocation(String query) async {
    if (query.trim().isEmpty) return;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=10');

    try {
      final res = await http.get(url, headers: {
        'User-Agent': 'FlutterOpenStreetMapApp/1.0 (abc_email@example.com)',
      });

      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final results = data.map((e) => LocationModel.fromJson(e)).toList();
        searchResults.assignAll(results);

        if (results.isNotEmpty) {
          updateSelectedLocation(
            LatLng(results.first.latitude, results.first.longitude),
          );
        } else {
          Get.snackbar('No Results', 'No location found for "$query"');
        }
      } else {
        Get.snackbar('Error', 'Failed to search location.');
      }
    } catch (e) {
      Get.snackbar('Exception', 'Something went wrong during search.');
    }
  }

  void _moveTo(LatLng latLng, double zoom) {
    mapController.move(latLng, zoom);
  }
}



