import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FarmBlock {
  final String id;
  final String name;
  final String variety;
  final double areaHa;
  final int plantCount;
  final List<LatLng> boundary;
  final Color color;

  FarmBlock({
    required this.id,
    required this.name,
    required this.variety,
    required this.areaHa,
    required this.plantCount,
    required this.boundary,
    required this.color,
  });

  // Auto-calculate the center of the polygon for the label
  LatLng get center {
    double lat = 0, lng = 0;
    for (var p in boundary) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / boundary.length, lng / boundary.length);
  }
}