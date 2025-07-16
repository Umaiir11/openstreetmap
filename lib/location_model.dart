class LocationModel {
  final double latitude;
  final double longitude;
  final String displayName;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.displayName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
      displayName: json['display_name'],
    );
  }
}
