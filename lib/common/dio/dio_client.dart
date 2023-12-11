import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_helper/common/dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../const/data.dart';

part 'dio_client.g.dart';

final dioClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio, baseUrl: 'http://$ip');
});

@RestApi()
abstract class DioClient {
  factory DioClient(Dio dio, {String baseUrl}) = _DioClient;


}