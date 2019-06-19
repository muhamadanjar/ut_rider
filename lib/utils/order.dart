import 'dart:async';
import '../data/rest_ds.dart';
import 'package:ut_order/models/order.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'constans.dart';
const kGoogleApiKey = google_web_api;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class OrderService{
  final RestDatasource _api;
  OrderService({RestDatasource api}) : _api = api;

  StreamController<Order> orderController = StreamController<Order>();
  Stream<Order> get order => orderController.stream;


  Future<Null> displayPrediction(Prediction p,type) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final name =  detail.result.name;
      var order = Order();
      order.destination = name;
      order.destinationLat = lat as String;
      order.destinationLng = lng as String;
      order.typeOrder = type;
      orderController.add(order);


    }
  }

}