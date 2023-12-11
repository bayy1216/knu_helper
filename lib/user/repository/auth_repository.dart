import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/dio/dio_client.dart';

final authRepositoryProvider = Provider((ref){
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient: dioClient);
});

class AuthRepository {
  final DioClient _dioClient;
  AuthRepository({required DioClient dioClient}) : _dioClient = dioClient;



}