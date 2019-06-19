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

  Future<dynamic> showPrediction(context,center) async{
    Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: (PlacesAutocompleteResponse response){
            print(response);
          },
          mode: Mode.fullscreen,
          language: "en",
          location: center == null ? null : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);
          return p;
  }

  Future<Null> displayPrediction(Prediction p,type) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final name =  detail.result.name;
      var order = Order();
      order.destination = name;
      order.destinationLat = lat;
      order.destinationLng = lng;
      order.typeOrder = type;
      orderController.add(order);
    }
  }

  void setDataOrder(name,lat,lng){
    var data = Order(origin: name,originLat: lat,originLng: lng);
    orderController.add(data);
  }

  

  
}