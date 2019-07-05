import 'dart:async';
import 'rest_ds.dart';
class AppBloc {
  RestDatasource api = new RestDatasource();
  StreamController<List> tipeSnapshotController = StreamController<List>();
  StreamSink<List> get tipeSnapshot => tipeSnapshotController.sink;
  Stream<List> get tipeSnapshotStream => tipeSnapshotController.stream;

  StreamController<List> packageSnapshotController = StreamController<List>();
  StreamSink<List> get packageSnapshot => packageSnapshotController.sink;
  Stream<List> get packageSnapshotStream => packageSnapshotController.stream;

  AppBloc(){
    api.getTypeMobil().then((List res){
      print("Print data ${res}");
      tipeSnapshot.add(res);
    });
  }

  void getType(){
    api.getTypeMobil().then((List res){
      print(res);
      tipeSnapshot.add(res);
    });

  }

  void getPackage(int idx){
    api.getPackage(idx).then((List res){
      print(res);
      packageSnapshot.add(res);
    });
  }

  void dispose() {
    print('disposed app bloc');
    tipeSnapshotController.close();
    packageSnapshotController.close();
  }
}