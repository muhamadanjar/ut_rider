import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/place_item_res.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:http/http.dart' as http;
import 'package:ut_order/utils/place.dart';
import '../models/base_model.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/subjects.dart';

class OrderViewModel extends BaseModel {
  double distance = 0;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  String token;
  List<PlacesSearchResult> places = [];
  Order _order;
  static const kGoogleApiKey = google_web_api;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  PublishSubject placeSubject;

  OrderViewModel({
    @required String token
  }) : token = token;

  setFrom(PlaceItemRes res){
    fromAddress = res;

    notifyListeners();
  }

  setTo(PlaceItemRes res){
    toAddress = res;
    notifyListeners();
  }
  postPesanan() async{
    final url = "${apiURL}/bookings/reguler";
    _order = new Order(origin: '',
      destination: '',originLat: 0,
      originLng: 0,
      destinationLat: 0,
      destinationLng: 0,
      typeOrder: 1,harga: 0,duration: 0,distance: 0);
      final response = await http.post(url,
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
      }
    print(_order);
    
  }

  int kalkulasiHarga(base,tempuhKm,tarifKm){
    var ta = base+(tempuhKm-(tempuhKm*0.01))*tarifKm;
    var tm = 0;
    return ta +tm;
  }
  void getNearbyPlaces(LatLng center) async {

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);
      setBusy(true);
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
          var markers = _createLatLng(f.geometry.location.lat, f.geometry.location.lng);
          setBusy(false);
        });
      } else {
        // this.errorMessage = result.errorMessage;
        setBusy(false);
      }
    
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      print(detail);
    }
  }
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    placeSubject.add("start");
    PlaceService.searchPlace(keyword).then((rs) {
      placeSubject.add(rs);
    }).catchError(() {
      placeSubject.add("stop");
    });
  }

}


