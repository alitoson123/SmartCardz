import 'package:dio/dio.dart';

class DioService {
  final Dio dio;

  DioService({required this.dio});

  // get method
  Future<List<dynamic>> getMethod({required String url}) async {
    var result = await dio.get(url);
    //  log(result.statusCode.toString());
    return result.data;
  }
}
