import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/models/farm_model.dart';
import 'package:pitayapro/core/network/api_client.dart';

final farmsProvider = FutureProvider<List<FarmModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get('/api/farms');
  if (response.statusCode == 200) {
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => FarmModel.fromJson(e as Map<String, dynamic>)).toList();
  }
  final body = jsonDecode(response.body);
  throw Exception(body['detail'] ?? 'Failed to load farms');
});

final farmProvider = FutureProvider.family<FarmModel, int>((ref, farmId) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get('/api/farms/$farmId');
  if (response.statusCode == 200) {
    return FarmModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
  final body = jsonDecode(response.body);
  throw Exception(body['detail'] ?? 'Farm not found');
});

class FarmActions {
  final Ref ref;
  FarmActions(this.ref);

  Future<FarmModel> create(Map<String, dynamic> body) async {
    final api = ref.read(apiClientProvider);
    final response = await api.post('/api/farms', body);
    if (response.statusCode == 201) {
      ref.invalidate(farmsProvider);
      return FarmModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to create farm');
  }

  Future<FarmModel> update(int farmId, Map<String, dynamic> body) async {
    final api = ref.read(apiClientProvider);
    final response = await api.put('/api/farms/$farmId', body);
    if (response.statusCode == 200) {
      ref.invalidate(farmsProvider);
      ref.invalidate(farmProvider(farmId));
      return FarmModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to update farm');
  }

  Future<void> delete(int farmId) async {
    final api = ref.read(apiClientProvider);
    final response = await api.delete('/api/farms/$farmId');
    if (response.statusCode == 204) {
      ref.invalidate(farmsProvider);
      return;
    }
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to delete farm');
  }
}

final farmActionsProvider = Provider<FarmActions>((ref) => FarmActions(ref));