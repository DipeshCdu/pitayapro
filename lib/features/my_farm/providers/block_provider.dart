import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitayapro/core/network/api_client.dart';
import 'package:pitayapro/core/models/block_model.dart';

// 1. List all blocks in a specific farm
final blocksProvider = FutureProvider.family<List<BlockModel>, int>((ref, farmId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/api/farms/$farmId/blocks');
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => BlockModel.fromJson(json)).toList();
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['detail'] ?? 'Failed to load blocks');
  }
});

// 2. Get one specific block
final blockProvider = FutureProvider.family<BlockModel, ({int farmId, int blockId})>((ref, params) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.get('/api/farms/${params.farmId}/blocks/${params.blockId}');
  if (response.statusCode == 200) {
    return BlockModel.fromJson(jsonDecode(response.body));
  } else {
    final body = jsonDecode(response.body);
    throw Exception(body['detail'] ?? 'Block not found');
  }
});

// 3. Create a new block in a farm
final createBlockProvider = Provider.family<void, ({int farmId, Map<String, dynamic> body})>((ref, params) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.post('/api/farms/${params.farmId}/blocks', params.body);
  if (response.statusCode == 201) {
    ref.invalidate(blocksProvider(params.farmId));
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to create block');
  }
});

// 4. Update an existing block
final updateBlockProvider = Provider.family<void, ({int farmId, int blockId, Map<String, dynamic> body})>((ref, params) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.put('/api/farms/${params.farmId}/blocks/${params.blockId}', params.body);
  if (response.statusCode == 200) {
    ref.invalidate(blocksProvider(params.farmId));
    ref.invalidate(blockProvider((farmId: params.farmId, blockId: params.blockId)));
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to update block');
  }
});

// 5. Delete a block
final deleteBlockProvider = Provider.family<void, ({int farmId, int blockId})>((ref, params) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.delete('/api/farms/${params.farmId}/blocks/${params.blockId}');
  if (response.statusCode == 204) {
    ref.invalidate(blocksProvider(params.farmId));
  } else {
    final resBody = jsonDecode(response.body);
    throw Exception(resBody['detail'] ?? 'Failed to delete block');
  }
});