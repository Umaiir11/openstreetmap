import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'map_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final controller = Get.find<MapControllerX>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: searchController,
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            controller.searchLocation(value.trim());
          }
        },
        decoration: InputDecoration(
          hintText: 'Search location...',
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              final query = searchController.text.trim();
              if (query.isNotEmpty) {
                controller.searchLocation(query);
              }
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
