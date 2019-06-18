
import 'package:ut_order/enum/connection_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkWidget extends StatelessWidget {
  const NetworkWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<ConnectivityStatus>(context);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (network == ConnectivityStatus.wifi ||
        network == ConnectivityStatus.mobileData) {
      return Container(
        child: child,
      );
    }

    return Container(
      height: _height,
      width: _width,
      child:Text("Tidak ada koneksi")
    );
  }
}
