import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

import 'map_controller.dart';
import 'widget.dart'; // Make sure SearchBarWidget is here

class OpenMapView extends StatefulWidget {
  const OpenMapView({Key? key}) : super(key: key);

  @override
  State<OpenMapView> createState() => _OpenMapViewState();
}

class _OpenMapViewState extends State<OpenMapView>
    with TickerProviderStateMixin {
  final MapControllerX controller = Get.put(MapControllerX());

  late AnimationController _fabAnimationController;
  late AnimationController _searchBarAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _searchBarSlideAnimation;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _searchBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _searchBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _searchBarAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      _searchBarAnimationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _fabAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _searchBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Obx(() {
          final LatLng initialCenter = controller.currentLocation.value;

          return Stack(
            children: [
              // Enhanced Map Layer
              FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: initialCenter.latitude == 0.0 && initialCenter.longitude == 0.0
                      ? const LatLng(20.0, 0.0)
                      : initialCenter,
                  initialZoom: initialCenter.latitude == 0.0 ? 2.0 : 16.0,
                  maxZoom: 20.0,
                  minZoom: 2.0,
                  onTap: (tapPosition, latlng) {
                    controller.updateSelectedLocation(latlng);
                  },
                ),
                children: [
                  // Modern Map Tiles
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.openstreetmap',
                    tileBuilder: (context, widget, tile) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.lighten,
                        ),
                        child: widget,
                      );
                    },
                  ),

                  // Enhanced Markers
                  MarkerLayer(
                    markers: [
                      // Current Location Marker
                      if (controller.currentLocation.value.latitude != 0.0)
                        Marker(
                          point: controller.currentLocation.value,
                          width: 60,
                          height: 60,
                          child: _buildCurrentLocationMarker(),
                        ),

                      // Selected Location Marker
                      if (controller.selectedLocation.value != null)
                        Marker(
                          point: controller.selectedLocation.value!,
                          width: 60,
                          height: 60,
                          child: _buildSelectedLocationMarker(),
                        ),
                    ],
                  ),
                ],
              ),

              // Modern Search Bar with Glassmorphism
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: SlideTransition(
                  position: _searchBarSlideAnimation,
                  child:  SearchBarWidget(),
                ),
              ),

              // Modern Bottom Controls Panel


              // Modern Floating Action Buttons
              Positioned(
                bottom: 120,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Locate Me Button
                    ScaleTransition(
                      scale: _fabScaleAnimation,
                      child: _buildModernFAB(
                        icon: Icons.my_location_rounded,
                        onPressed: () => controller.fetchCurrentLocation(),
                        heroTag: "locate_me",
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Layers Button

                    // Zoom In Button
                    ScaleTransition(
                      scale: _fabScaleAnimation,
                      child: _buildModernFAB(
                        icon: Icons.add_rounded,
                        onPressed: () => _zoomIn(),
                        heroTag: "zoom_in",
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Zoom Out Button
                    ScaleTransition(
                      scale: _fabScaleAnimation,
                      child: _buildModernFAB(
                        icon: Icons.remove_rounded,
                        onPressed: () => _zoomOut(),
                        heroTag: "zoom_out",
                      ),
                    ),
                  ],
                ),
              ),

              // Modern Menu Button

            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentLocationMarker() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade600,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.blue.shade600, width: 3),
        ),
        child: Icon(
          Icons.navigation_rounded,
          color: Colors.blue.shade600,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSelectedLocationMarker() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade600,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300.withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.red.shade600, width: 3),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.red.shade600,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernFAB({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton(
            heroTag: heroTag,
            backgroundColor: Colors.white.withOpacity(0.9),
            foregroundColor: Colors.black87,
            elevation: 0,
            onPressed: onPressed,
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }



  Widget _buildBottomControlItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _zoomIn() {
    controller.mapController.move(
      controller.mapController.center,
      controller.mapController.zoom + 1,
    );
  }

  void _zoomOut() {
    controller.mapController.move(
      controller.mapController.center,
      controller.mapController.zoom - 1,
    );
  }


}