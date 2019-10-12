import '../data/rest_ds.dart';
import 'package:google_maps_webservice/places.dart';
import 'constans.dart';
const kGoogleApiKey = google_web_api;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class OrderService{
  final RestDatasource _api;
  OrderService({RestDatasource api}) : _api = api;



  

  
}