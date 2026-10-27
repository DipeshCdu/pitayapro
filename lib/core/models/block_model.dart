class BlockModel {
  final int blockId;
  final int farmId;
  final String blockName;
  final double? area;
  final double? latitude;
  final double? longitude;
  final String? growingSystem;
  final String? trellisSystem;
  final String? irrigationSystem;
  final String? soilType;
  final String? mulchingType;
  final String? notes;

  BlockModel({
    required this.blockId,
    required this.farmId,
    required this.blockName,
    this.area,
    this.latitude,
    this.longitude,
    this.growingSystem,
    this.trellisSystem,
    this.irrigationSystem,
    this.soilType,
    this.mulchingType,
    this.notes,
  });

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      blockId: json['blockId'],
      farmId: json['farmId'],
      blockName: json['blockName'],
      area: json['area']?.toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      growingSystem: json['growingSystem'],
      trellisSystem: json['trellisSystem'],
      irrigationSystem: json['irrigationSystem'],
      soilType: json['soilType'],
      mulchingType: json['mulchingType'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blockName': blockName,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
      'growingSystem': growingSystem,
      'trellisSystem': trellisSystem,
      'irrigationSystem': irrigationSystem,
      'soilType': soilType,
      'mulchingType': mulchingType,
      'notes': notes,
    };
  }
}