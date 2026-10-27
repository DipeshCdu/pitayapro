import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/network/api_client.dart';
import 'package:pitayapro/core/models/farm_model.dart';

// 1. List all farms
final farmsProvider = FutureProvider<List<FarmModel>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/api/farms');
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => FarmModel.fromJson(json)).toList();
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['detail'] ?? 'Failed to load farms');
  }
});

// 2. Get one farm by ID
final farmProvider = FutureProvider.family<FarmModel, int>((ref, farmId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/api/farms/$farmId');
  if (response.statusCode == 200) {
    return FarmModel.fromJson(jsonDecode(response.body));
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['detail'] ?? 'Farm not found');
  }
});

// 3. Create a new farm
final createFarmProvider = Provider.family<void, Map<String, dynamic>>((ref, body) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post('/api/farms', body);
  if (response.statusCode == 201) {
    ref.invalidate(farmsProvider);
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to create farm');
  }
});

// 4. Update an existing farm
final updateFarmProvider = Provider.family<void, ({int farmId, Map<String, dynamic> body})>((ref, params) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put('/api/farms/${params.farmId}', params.body);
  if (response.statusCode == 200) {
    ref.invalidate(farmsProvider);
    ref.invalidate(farmProvider(params.farmId));
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to update farm');
  }
});

// 5. Delete a farm
final deleteFarmProvider = Provider.family<void, int>((ref, farmId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.delete('/api/farms/$farmId');
  if (response.statusCode == 204) {
    ref.invalidate(farmsProvider);
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to delete farm');
  }
});