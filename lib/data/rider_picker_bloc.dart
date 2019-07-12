import 'package:flutter/widgets.dart';

import '../models/base_model.dart';
import '../models/place_item_res.dart';
import 'rest_ds.dart';
class RiderPickerBloc extends BaseModel{
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  final RestDatasource _api;

  RiderPickerBloc({
    @required RestDatasource rs,
  }) : _api = rs;

  int kalkulasiHarga(base,tempuh_km,tarif_km){
    var ta = base+(tempuh_km-1)*tarif_km;
    var tm = 0;
    return ta +tm;
  }
  void setOrigin(){
    notifyListeners();
  }
  void setDestination(){
    notifyListeners();
  }
}