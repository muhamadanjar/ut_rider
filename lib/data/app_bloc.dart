import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:ut_order/models/promo.dart';
import 'rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:ut_order/utils/constans.dart';
class AppBloc {
  RestDatasource api = new RestDatasource();
  PublishSubject<List> tipeMobil = PublishSubject<List>();
  Observable<List> get tipe => tipeMobil.stream;


  StreamController<List> packageSnapshotController = StreamController<List>();
  StreamSink<List> get packageSnapshot => packageSnapshotController.sink;
  Stream<List> get packageSnapshotStream => packageSnapshotController.stream;

  StreamController<List> serviceSnapshotController = StreamController<List>();
  StreamSink<List> get serviceSnapshot => serviceSnapshotController.sink;
  Stream<List> get serviceSnapshotStream => serviceSnapshotController.stream;

  PublishSubject<List<Promo>> _promoSubject = PublishSubject<List<Promo>>();
  PublishSubject<List<Promo>> get promoSubject => _promoSubject;

  AppBloc(){
    api.getTypeMobil().then((List res){
      print("Print data ${res}");
      tipeMobil.add(res);
    });

    // api.getPackage(0).then((List res){
    //   print("Print data ${res}");
    //   packageSnapshot.add(res);
    // });
    _loadSharedPrefs();
    _loadPromo();



  }


  void getPackage(int idx){
    api.getPackage(idx).then((List res){
      print(res);
      packageSnapshot.add(res);
    });
  }
  void getServiceType(){
    api.getServiceType().then((List res){
      print(res);
      serviceSnapshot.add(res);
    });

  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    bool showWebView = sharedPrefs.getBool('showWebView') ?? false;

  }

  Future<void> _loadPromo() async {
    final JsonDecoder _decoder = new JsonDecoder();
    http.get("${apiURL}/get_promo").then((http.Response response){
      var res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }
      try{
        var json = _decoder.convert(res);
        var listPromo = new List<Promo>();
        (json['data'] as List).forEach((f) {
          var data = Promo(name: f["name"],
              kodePromo: f["kode_promo"],
              discount: (f["discount"]),
              imgUrl: f["image_path"]);
          listPromo.add(data);
        });
        print(listPromo);
        _promoSubject.sink.add(listPromo);
      }catch(err){
        print(err);
      }

    });
  }

  void dispose() {
    print('disposed app bloc');
    tipeMobil.close();
    packageSnapshotController.close();
  }
}

class AppState with ChangeNotifier{

}