import 'dart:convert';
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

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final Position? position = await _determinePosition();
      if (position == null) return;

      final latLng = LatLng(position.latitude, position.longitude);
      currentLocation(latLng); // More efficient than `.value =`
      _moveTo(latLng, 15.0);
    } catch (e) {
      print('📍 Location error: $e');
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void updateSelectedLocation(LatLng location) {
    selectedLocation(location);
  }

  Future<void> searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$trimmed&format=json&addressdetails=1&limit=10',
    );

    try {
      final res = await http.get(url, headers: {
        'User-Agent': 'FlutterOpenStreetMapApp/1.0 (your_email@example.com)',
      });

      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final results = data.map((e) => LocationModel.fromJson(e)).toList();

        searchResults.assignAll(results);

        if (results.isNotEmpty) {
          setLocationFromSearch(results.first);
        } else {
          Get.snackbar('Not Found', 'No location found for "$query"',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        print('❌ HTTP ${res.statusCode} during search');
      }
    } catch (e) {
      print('❌ Exception during search: $e');
    }
  }

  void setLocationFromSearch(LocationModel loc) {
    final latLng = LatLng(loc.latitude, loc.longitude);
    selectedLocation(latLng);
    _moveTo(latLng, 16.0);
  }

  void _moveTo(LatLng latLng, double zoom) {
    mapController.move(latLng, zoom);
  }
}
