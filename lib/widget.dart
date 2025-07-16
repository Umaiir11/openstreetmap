import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'map_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final controller = Get.find<MapControllerX>();
  final TextEditingController searchController = TextEditingController();

  SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Box
        Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: searchController,
            // onChanged: (value) {
            //   if (value.trim().length >= 3) {
            //     controller.searchLocation(value);
            //   } else {
            //     controller.searchResults.clear();
            //   }
            // },
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                controller.searchLocation(value);
              }
            },
            style: const TextStyle(color: Colors.black), // 🟢 Text color = black
            decoration: InputDecoration(
              hintText: 'Search location...',
              hintStyle: const TextStyle(color: Colors.black54),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  searchController.clear();
                  controller.searchResults.clear();
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        // 📍 Results Dropdown
        Obx(() {
          final results = controller.searchResults;
          if (results.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: Text(
                    item.displayName,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    controller.updateSelectedLocation(
                      LatLng(item.latitude, item.longitude),
                    );
                    searchController.text = item.displayName;
                    controller.searchResults.clear(); // Hide dropdown
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
