import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:knu_helper/common/provider/navigation_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../const/data.dart';
import '../secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.addAll([
    CustomInterceptor(storage: storage,ref: ref),
    PrettyDioLogger(
      requestBody: true,
    ),
  ]);

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;
  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{

    if(options.headers['refreshToken'] == 'true'){
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'Authorization' : 'Bearer $token',
      });

      return super.onRequest(options, handler);
    }
    if(options.headers['accessToken'] =='false'){
      options.headers.remove('accessToken');
      return super.onRequest(options, handler);
    }


    final token = await storage.read(key: ACCESS_TOKEN_KEY);

    options.headers.addAll({
      'Authorization' : 'Bearer $token',
    });
    return super.onRequest(options, handler);

  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refresh토큰이 아에 없으면 에러(로그인을 하지 않았음)
    if (refreshToken == null){
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh){//refresh로 다시 accessToken 재발급 요청 보내기
      final dio = Dio();
      try{

        //final fcmToken = await FirebaseMessaging.instance.getToken();
        final resp = await dio.get('http://$ip/auth/token',
          options: Options(
            headers: {
              'Authorization' : refreshToken,
            },
          ),
          // data: {
          //   'fcmToken' : fcmToken,
          // },
        );


        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;
        options.headers.addAll({
          'Authorization' : '$accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송
        final response = await dio.fetch(options);

        return handler.resolve(response);
      }on DioException catch(e){
        ref.read(navigationProvider.notifier).logout();
        return handler.reject(e);
      }
    }

    return super.onError(err, handler);
  }
}