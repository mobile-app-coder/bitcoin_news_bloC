import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'http_helper.dart';

class Network {
  static const String API_KEY = "1533026a3de741a3a8d3cdb44aaa703e";
  static String BASE = "newsapi.org";
  static String API = "/v2/everything";

  static final client = InterceptedClient.build(
    interceptors: [HttpInterceptor()],
    retryPolicy: HttpRetryPolicy(),
  );

  /* Http Requests */
  static Future<String?> GET() async {
    try {
      var uri = Uri.https(BASE, API, params());
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        _throwException(response);
      }
    } on SocketException catch (_) {
      // if the network connection fails
      rethrow;
    }
  }

  static Map<String, dynamic> params() {
    Map<String, dynamic> param = {'q': "bitcoin", 'apiKey': API_KEY};
    return param;
  }

  static _throwException(Response response) {
    String reason = response.reasonPhrase!;
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }
}
