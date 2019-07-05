import 'dart:async';
import 'package:ut_order/models/tipemobil.dart';
import 'package:ut_order/utils/network_util.dart';
import 'package:ut_order/models/user.dart';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/promo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database_helper.dart';
class RestDatasource {
  NetworkUtil _networkUtil = new NetworkUtil();

  static final BASE_URL = apiURL;
  static final LOGIN_URL = BASE_URL + "/login";
  static final REGISTER_URL = BASE_URL + "/register";
  static final LOGOUT_URL = BASE_URL + "/logout";
  static final UPDATE_LOCATION =  BASE_URL + "/user/update_position";
  static final GET_USER =  BASE_URL + "/user/details";
  static final SET_STATUS_ONLINE =  BASE_URL + "/user/changeonline";
  static final CHECK_JOB =  BASE_URL + "/driver/checkjob";
  static final ORDER_CAR =  BASE_URL + "/reguler";
  static final GET_PACKAGE =  BASE_URL + "/rent_package";
  static final GET_PROMO = BASE_URL + "/get_promo";
  static final GET_TYPEMOBIL = BASE_URL + "/type_car";
  static final POST_RENTAL = BASE_URL + "reguler";
  static final POST_TAXI = BASE_URL + "order";
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
      return new User.fromJson(res["data"]['user']);
    }).catchError((res){ return res;});
  }

  Future<dynamic> register(Map mapData){
    
    
    var data = {
      "username": mapData['email'],
      "password": (mapData["password"] as String),
      "c_password": (mapData["c_password"] as String),
      "email": (mapData["email"] as String),
      "name": (mapData["name"] as String),
      "no_telepon": (mapData['no_telepon'] as String),
    };
    var headers ={
      'Accept': 'application/json',
    };

    return _networkUtil.post(REGISTER_URL,body:data,headers: headers).then((dynamic res){
      return res;
    });  
    

  }
  Future<dynamic> logout(){
    var db = new DatabaseHelper();
    return _networkUtil.get(LOGOUT_URL).then((dynamic res){
      SharedPreferences.getInstance().then((pref){
        pref.clear();
        db.deleteUsers();
      });
    });
  }

  Future<User> getUser(String token){
    var data = {'token':token};
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return _networkUtil.post(GET_USER,body:data,headers: headers).then((dynamic res){
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
  Future<void> checkJob(){
    var body = {
      'driverId':'1'
    };
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return _networkUtil.post(CHECK_JOB,body: body,headers: headers).then((dynamic res){
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
    List listPackage = new List();
    (response['data'] as List).forEach((f){
        var data = new Map<String,dynamic>();
        data['id'] = f['rp_id'];
        data['name'] = f['rp_name'];
        data['harga'] = f['rp_total_price'];
        data['harga_km'] = f['rp_miles_km'];
        data['harga_jam'] = f['rp_hour'];
        data['harga_addkm'] = f['rp_add_mile_km'];
        data['harga_addmenit'] = f['rp_add_min'];
        listPackage.add(data);
      }
    );
    return listPackage;
  }
  Future<List> getTypeMobil() async{
    var response = await _networkUtil.get("${GET_TYPEMOBIL}");
    List listType = new List();
    (response["data"] as List).forEach((f){
        var data = new Map<String,dynamic>();
        data["id"] = f["id"];
        data["name"] = f["type"];
        data["imgUrl"] = f["path_url"];
        listType.add(data);
    });
    return listType;
  }
  Future<List<Promo>> getPromo() async{
    var response = await _networkUtil.get("${GET_PROMO}");
    var listPromo = new List<Promo>();
    (response["data"] as List).forEach((f){
      var data = Promo(name: f["name"],kodePromo: f["kode_promo"],discount: (f["discount"]),imgUrl: f["image_path"]);
      listPromo.add(data);
    });

    return listPromo;

  }
  Future<dynamic> orderCar(Order order){
    var data = {
      'trip_address_origin': order.origin,
      'trip_or_origin':order.originLat,
      'trip_or_longitude':order.originLng,
      'trip_address_destination':order.destination,
      'trip_des_latitude':order.originLat,
      'trip_des_longitude':order.originLng,
      'trip_bookby':'24',
      'trip_job':'4',
      'trip_total':'1910',
      'duration':'5145',
      'distance':'39720',
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