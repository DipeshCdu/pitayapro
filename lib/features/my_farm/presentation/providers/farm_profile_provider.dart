import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmProfile {
  final String name;
  final String owner;
  final String address;
  final String climateZone;
  final String growingSystem;
  final String trellisSystem;
  final String irrigationSystem;
  final String cropType;
  final String soilType;
  final String mulchType;
  final String notes;
  final double? latitude;
  final double? longitude;

  const FarmProfile({
    required this.name,
    required this.owner,
    required this.address,
    required this.climateZone,
    required this.growingSystem,
    required this.trellisSystem,
    required this.irrigationSystem,
    this.cropType = 'Dragon Fruit',
    this.soilType = 'In-ground',
    this.mulchType = 'Organic Mulch',
    this.notes = '',
    this.latitude,
    this.longitude,
  });

  FarmProfile copyWith({
    String? name,
    String? owner,
    String? address,
    String? climateZone,
    String? growingSystem,
    String? trellisSystem,
    String? irrigationSystem,
    String? cropType,
    String? soilType,
    String? mulchType,
    String? notes,
    double? latitude,
    double? longitude,
  }) {
    return FarmProfile(
      name: name ?? this.name,
      owner: owner ?? this.owner,
      address: address ?? this.address,
      climateZone: climateZone ?? this.climateZone,
      growingSystem: growingSystem ?? this.growingSystem,
      trellisSystem: trellisSystem ?? this.trellisSystem,
      irrigationSystem: irrigationSystem ?? this.irrigationSystem,
      cropType: cropType ?? this.cropType,
      soilType: soilType ?? this.soilType,
      mulchType: mulchType ?? this.mulchType,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class FarmProfileNotifier extends StateNotifier<FarmProfile> {
  FarmProfileNotifier()
      : super(
          const FarmProfile(
            name: 'Pitaya Pro Farm',
            owner: 'Ramesh',
            address: 'Northern Territory, Australia',
            climateZone: 'Tropical',
            growingSystem: 'Open Field',
            trellisSystem: 'T-bar Trellis',
            irrigationSystem: 'Drip Irrigation',
            cropType: 'Dragon Fruit',
            soilType: 'In-ground',
            mulchType: 'Organic Mulch',
            notes: '',
          ),
        );

  void update(FarmProfile profile) {
    state = profile;
  }
}

final farmProfileProvider =
    StateNotifierProvider<FarmProfileNotifier, FarmProfile>((ref) {
  return FarmProfileNotifier();
});