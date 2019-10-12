import 'package:google_maps_webservice/places.dart';
import 'constans.dart';
import 'network_util.dart';
const kGoogleApiKey = google_web_api;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class OrderService{
  final NetworkUtil _api;
  OrderService({NetworkUtil api}) : _api = api;



  

  
}