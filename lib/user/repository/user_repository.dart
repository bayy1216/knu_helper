import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/dio/dio_client.dart';

final userRepositoryProvider = Provider<UserRepository>((ref){
  final dioClient = ref.watch(dioClientProvider);

  return UserRepository(dioClient: dioClient);
});

class UserRepository {
  final DioClient _dioClient;
  UserRepository({required DioClient dioClient}) : _dioClient = dioClient;




}