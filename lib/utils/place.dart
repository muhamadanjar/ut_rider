import 'dart:async';
import '../utils/constans.dart';

import 'package:ut_order/models/place_item_res.dart';
import 'package:ut_order/models/step_res.dart';
import 'package:ut_order/models/trip_info_res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            google_web_api +"&language=id&region=ID&query=" + Uri.encodeQueryComponent(keyword);
    print("search >>: " + url);
    var res = await http.get(url);
    if (res.statusCode == 200) {
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return new List();
    }
  }

  static Future<dynamic> getStep(double lat, double lng, double tolat, double tolng) async {
    String str_origin = "origin=" + lat.toString() + "," + lng.toString();
    // Destination of route
    String str_dest =
        "destination=" + tolat.toString() + "," + tolng.toString();
    // Sensor enabled
    String sensor = "sensor=false";
    String mode = "mode=driving";
    // Building the parameters to the web service
    String parameters = str_origin + "&" + str_dest + "&" + sensor + "&" + mode;
    // Output format
    String output = "json";
    // Building the url to the web service
    String url = "https://maps.googleapis.com/maps/api/directions/" +
        output +
        "?" +
        parameters +
        "&key=" +
        google_web_api;

    print(url);
    final JsonDecoder _decoder = new JsonDecoder();
    return http.get(url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
//      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }


      TripInfoRes tripInfoRes;
      try {
        var json = _decoder.convert(res);
        int distance = json["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps = _parseSteps(json["routes"][0]["legs"][0]["steps"]);

        tripInfoRes = new TripInfoRes(distance, steps);

      } catch (e) {
        throw new Exception(res);
      }
      print("get Step: ${tripInfoRes}");
      return tripInfoRes;
    });
  }

  static List<StepsRes> _parseSteps(final responseBody) {
    var list = responseBody
        .map<StepsRes>((json) => new StepsRes.fromJson(json))
        .toList();

    return list;
  }

  static Future<List> getNearbyPlace(double lat,double lng,double radius) async{
    var location = "${lat.toString()},${lng.toString()}";
    var _rad = radius.toString();
    String nearbyurl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?key="+ google_web_api+"&location="+location+"&radius="+_rad;
    var res = await http.get(nearbyurl);
    if(res.statusCode == 200){
      print(res.body);
      return PlaceItemRes.fromJson(json.decode(res.body));
    }else{
      return new List();
    }

  }
}
