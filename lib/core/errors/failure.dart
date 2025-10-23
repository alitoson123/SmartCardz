import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;
  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});

  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errorMessage: "Connection timeout with the server.",
        );
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errorMessage: "Request send timeout. Please try again.",
        );
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errorMessage: "Receive timeout from the server.");
      case DioExceptionType.badCertificate:
        return ServerFailure(errorMessage: "Bad SSL certificate detected.");
      case DioExceptionType.badResponse:
        return ServerFailure.fromBadResponse(
          statusCode: dioException.response?.statusCode,
          response: dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          errorMessage: "Request to the server was cancelled.",
        );
      case DioExceptionType.connectionError:
        return ServerFailure(
          errorMessage: "No internet connection or network error.",
        );
      case DioExceptionType.unknown:
        return ServerFailure(
          errorMessage: "Unexpected error occurred: ${dioException.message}",
        );
    }
  }

  factory ServerFailure.fromBadResponse({int? statusCode, dynamic response}) {
    if (statusCode == null) {
      return ServerFailure(errorMessage: "Unknown server response.");
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(
          errorMessage: "Bad request. Please check your input.",
        );
      case 401:
        return ServerFailure(errorMessage: "Unauthorized. Please login again.");
      case 403:
        return ServerFailure(errorMessage: "Forbidden. You don’t have access.");
      case 404:
        return ServerFailure(errorMessage: "Requested resource not found.");
      case 500:
        return ServerFailure(
          errorMessage: "Internal server error. Please try later.",
        );
      case 502:
        return ServerFailure(errorMessage: "Bad gateway.");
      case 503:
        return ServerFailure(
          errorMessage: "Service unavailable. Try again later.",
        );
      case 504:
        return ServerFailure(errorMessage: "Gateway timeout.");
      default:
        return ServerFailure(
          errorMessage: "There was an error please try again.",
        );
    }
  }
}
