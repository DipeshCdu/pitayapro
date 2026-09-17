import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GrowingSystemType { openField, greenhouse, shadeStructure }
enum TrellisType { concrete, timber, tyre, tbar, potted, other }
enum IrrigationType { drip, spray, flood, manual, automated }
enum SoilType { sandy, loam, clay, improved }
enum MulchType { organic, plastic, none }

class FarmProfileData {
  String farmName;
  String ownerName;
  String address;
  double? latitude;
  double? longitude;
  String region;
  GrowingSystemType growingSystem;
  TrellisType trellisType;
  IrrigationType irrigationType;
  SoilType soilType;
  MulchType mulchType;
  String customTrellis;
  String notes;

  FarmProfileData({
    this.farmName = '',
    this.ownerName = '',
    this.address = '',
    this.latitude,
    this.longitude,
    this.region = '',
    this.growingSystem = GrowingSystemType.openField,
    this.trellisType = TrellisType.concrete,
    this.irrigationType = IrrigationType.drip,
    this.soilType = SoilType.loam,
    this.mulchType = MulchType.organic,
    this.customTrellis = '',
    this.notes = '',
  });

  FarmProfileData copyWith({
    String? farmName,
    String? ownerName,
    String? address,
    double? latitude,
    double? longitude,
    String? region,
    GrowingSystemType? growingSystem,
    TrellisType? trellisType,
    IrrigationType? irrigationType,
    SoilType? soilType,
    MulchType? mulchType,
    String? customTrellis,
    String? notes,
  }) {
    return FarmProfileData(
      farmName: farmName ?? this.farmName,
      ownerName: ownerName ?? this.ownerName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      growingSystem: growingSystem ?? this.growingSystem,
      trellisType: trellisType ?? this.trellisType,
      irrigationType: irrigationType ?? this.irrigationType,
      soilType: soilType ?? this.soilType,
      mulchType: mulchType ?? this.mulchType,
      customTrellis: customTrellis ?? this.customTrellis,
      notes: notes ?? this.notes,
    );
  }
}

final farmProfileProvider = StateNotifierProvider<FarmProfileNotifier, FarmProfileData>((ref) {
  return FarmProfileNotifier();
});

class FarmProfileNotifier extends StateNotifier<FarmProfileData> {
  FarmProfileNotifier() : super(FarmProfileData());

  void updateFarmName(String name) => state = state.copyWith(farmName: name);
  void updateOwnerName(String name) => state = state.copyWith(ownerName: name);
  void updateAddress(String addr) => state = state.copyWith(address: addr);
  void updateRegion(String region) => state = state.copyWith(region: region);
  void updateGPS(double lat, double lng) {
    state = state.copyWith(latitude: lat, longitude: lng);
  }
  void updateGrowingSystem(GrowingSystemType type) {
    state = state.copyWith(growingSystem: type);
  }
  void updateTrellisType(TrellisType type) {
    state = state.copyWith(trellisType: type);
  }
  void updateIrrigationType(IrrigationType type) {
    state = state.copyWith(irrigationType: type);
  }
  void updateSoilType(SoilType type) {
    state = state.copyWith(soilType: type);
  }
  void updateMulchType(MulchType type) {
    state = state.copyWith(mulchType: type);
  }
  void updateCustomTrellis(String text) {
    state = state.copyWith(customTrellis: text);
  }
  void updateNotes(String text) {
    state = state.copyWith(notes: text);
  }

  void saveProfile() {
    // TODO: Save to database/Supabase
    print('Farm profile saved: ${state.farmName}');
  }
}