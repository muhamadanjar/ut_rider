import 'dart:async';
import 'package:flutter/widgets.dart';

import 'rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppBloc {
  RestDatasource api = new RestDatasource();
  StreamController<List> tipeSnapshotController = StreamController<List>();
  StreamSink<List> get tipeSnapshot => tipeSnapshotController.sink;
  Stream<List> get tipeSnapshotStream => tipeSnapshotController.stream;

  StreamController<List> packageSnapshotController = StreamController<List>();
  StreamSink<List> get packageSnapshot => packageSnapshotController.sink;
  Stream<List> get packageSnapshotStream => packageSnapshotController.stream;

  StreamController<List> serviceSnapshotController = StreamController<List>();
  StreamSink<List> get serviceSnapshot => serviceSnapshotController.sink;
  Stream<List> get serviceSnapshotStream => serviceSnapshotController.stream;

  AppBloc(){
    api.getTypeMobil().then((List res){
      print("Print data ${res}");
      tipeSnapshot.add(res);
    });

    api.getPackage(0).then((List res){
      print("Print data ${res}");
      packageSnapshot.add(res);
    });
    _loadSharedPrefs();


  }

  void getType(){
    api.getTypeMobil().then((List res){
//      print(res);
      tipeSnapshot.add(res);

    });

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
    var showWebView = sharedPrefs.getBool('showWebView') ?? false;

  }

  void dispose() {
    print('disposed app bloc');
    tipeSnapshotController.close();
    packageSnapshotController.close();
  }
}

class AppState with ChangeNotifier{

}