import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:ut_order/enum/connection_status.dart';
class ConnectivityService {
  ///Connection status controller....
  StreamController<ConnectivityStatus> connectivityController = StreamController<ConnectivityStatus>();

  ///Fetch the Connection Status...
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult status) {
      var _connectionStatus = _networkStatus(status);

      ///Emit the status via Stream...
      connectivityController.add(_connectionStatus);
    });
  }
  Stream<ConnectivityStatus> get connection => connectivityController.stream;
  //Converts the connectivity result into our enums
  //Currently the output id mobile, wifi,none.....
  ConnectivityStatus _networkStatus(ConnectivityResult status) {
    //Begin...
    
    switch (status) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.mobileData;

      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;

      case ConnectivityResult.none:
        return ConnectivityStatus.offline;

      default:
        return ConnectivityStatus.offline;
    }
  }
}


