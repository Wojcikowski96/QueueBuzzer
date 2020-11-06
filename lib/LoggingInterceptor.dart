import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  final storage = FlutterSecureStorage();
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      String jwt = await storage.read(key: "jwt").toString();
      data.headers["Authorization"] = "Bearer $jwt";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async => data;
}