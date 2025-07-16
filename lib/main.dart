import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:openstreetmap/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.requestPermission();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OpenMapView(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    ),
  );
}
