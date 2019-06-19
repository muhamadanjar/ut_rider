import 'dart:async';
import 'package:ut_order/utils/network_util.dart';
import 'package:ut_order/models/user.dart';
import 'package:ut_order/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database_helper.dart';
import 'package:ut_order/models/package.dart';
class RestDatasource {
  NetworkUtil _networkUtil = new NetworkUtil();

  static final BASE_URL = apiURL;
  static final LOGIN_URL = BASE_URL + "/login";
  static final LOGOUT_URL = BASE_URL + "/logout";
  static final UPDATE_LOCATION =  BASE_URL + "/user/update_position";
  static final GET_USER =  BASE_URL + "/user/details";
  static final SET_STATUS_ONLINE =  BASE_URL + "/user/changeonline";
  static final CHECK_JOB =  BASE_URL + "/driver/checkjob";
  static final ORDER_CAR =  BASE_URL + "/reguler";
  static final GET_PACKAGE =  BASE_URL + "/rent_package";
  static final GET_PROMO = BASE_URL + "/get_promo";
  static final _API_KEY = "somerandomkey";
  final token = 'token';
  LocationData _currentLocation;
  

  Future<String> getPrefs(key) async {
    var _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(key);
  }

  Future<dynamic> login(String username, String password) {
    var data = {
      "username": username,
      "password": password,
      "token": _API_KEY,
    };
    var headers ={
      'Accept': 'application/json',
    };
    return _networkUtil.post(LOGIN_URL,body:data,headers: headers).then((dynamic res) async {
      print(res);
      if(res["error"] == true) throw new Exception(res["message"]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', res['data']['token']);
      return new User.fromJson(res["data"]);
    }).catchError((res){ return res;});
  }

  Future<dynamic> logout(){
    var db = new DatabaseHelper();
    return _networkUtil.get(LOGOUT_URL).then((dynamic res)=>{
      SharedPreferences.getInstance().then((pref){
        pref.clear();
        db.deleteUsers();
      })
    });
  }

  Future<User> getUser(String token){
    var data = {'token':token};
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    _networkUtil.post(GET_USER,body:data,headers: headers).then((dynamic res){
      return User.fromJson(res['data']);
    });
  }

  Future<dynamic> updateLocation(String latitude,String longitude){
    var data = {
      'latitude': latitude,
      'longitude': longitude,
      'latest_update': new DateTime.now().toString()
    };
    var token = getPrefs('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    
    return _networkUtil.post(UPDATE_LOCATION,body:data,headers: headers).then((dynamic res){
      print(res);
    });
  }
  Future<dynamic> changeStatusOnline(String status){
    var data = {
      'online' : status
    };
    return _networkUtil.post(SET_STATUS_ONLINE,body: data).then((dynamic res){
      print(res);
    });
  }
  Future<dynamic> checkJob(){
    var body = {
      'driverId':'1'
    };
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    _networkUtil.post(CHECK_JOB,body: body,headers: headers).then((dynamic res){
      print(res);
    });
  }

  Future<LatLng> getUserLocation() async {

    final location = new Location();
    try {
      _currentLocation = await location.getLocation();
      print(_currentLocation);
      final lat = _currentLocation.latitude;
      final lng = _currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      _currentLocation = null;
      return null;
    }
  }
  Future<List> getPackage(type) async{
    var response = await _networkUtil.get("${GET_PACKAGE}/${type}");
    List list_package = new List();
    var result =(response['data'] as List).forEach((f){
        var data = new Map<String,dynamic>();
        data['id'] = f['rp_id'];
        data['name'] = f['rp_name'];
        data['harga'] = f['rp_total_price'];
        data['harga_km'] = f['rp_miles_km'];
        data['harga_jam'] = f['rp_hour'];
        data['harga_addkm'] = f['rp_add_mile_km'];
        data['harga_addmenit'] = f['rp_add_min'];
        list_package.add(data);
      }
    );
    return list_package;



  }
  Future<List> getPromo() async{
    var response = await _networkUtil.get("${GET_PROMO}");
    var list_promo = new List();
    var result = (response["data"] as List).forEach((f){
      var data = new Map();
      data["name"] =  f["name"];
      data["kodepromo"] =  f["kode_promo"];
      data["discount"] =  f["discount"];
      list_promo.add(data);
    });

    return list_promo;

  }
  Future<dynamic> orderCar(Order order){
    var data = {
      'trip_address_origin':'Bogor, West Java, Indonesia',
   'trip_or_origin':'-6.551775799999999',
    'trip_or_longitude':'106.6291304',
    'trip_address_destination':'Cibinong, Bogor, West Java, Indonesia',
    'trip_des_latitude':'-6.4901067',
    'trip_des_longitude':'106.8306951',
    'trip_bookby':'24',
    'trip_job':'4',
    'trip_total':'1910',
    'duration':'5145',
    'distance':'39720',
    'rent_package':'1'
    };
    var token = getPrefs('token');
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print(data);
    return _networkUtil.post(ORDER_CAR,body:data,headers: headers).then((dynamic res){
      return res;
    });
  }
}   