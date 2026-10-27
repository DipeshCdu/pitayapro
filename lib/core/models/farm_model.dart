class FarmModel {
  final int farmId;
  final String farmName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? region;
  final String? climateZone;
  final String? createdAt;

  FarmModel({
    required this.farmId,
    required this.farmName,
    this.address,
    this.latitude,
    this.longitude,
    this.region,
    this.climateZone,
    this.createdAt,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      farmId: json['farmId'],
      farmName: json['farmName'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      region: json['region'],
      climateZone: json['climateZone'],
      createdAt: json['createdAt'],
    );
  }

  // Convert back to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      'farmName': farmName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'climateZone': climateZone,
    };
  }
}