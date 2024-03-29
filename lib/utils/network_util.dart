import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
class NetworkUtil {
  
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data from ${url}");
      }
      return _decoder.convert(res);
    });
  }

    Future<dynamic> post(String url, {Map headers, body, encoding}) async{
      return http
          .post(url, body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
         print(statusCode);
        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error while fetching data from " + body.toString() + " "+body.toString());
//          return _decoder.convert(res);
        }
        return _decoder.convert(res);
      });
    }
  }