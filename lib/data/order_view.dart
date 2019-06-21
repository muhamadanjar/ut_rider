import 'package:flutter/widgets.dart';
import 'package:ut_order/utils/order.dart';
import '../models/base_model.dart';

class OrderViewModel extends BaseModel {
  OrderService _orderService;

  OrderViewModel({
    @required OrderService orderService,
  }) : _orderService = orderService;
  Future<Null> showPrediction(context,center) async{

    
  }
  Future<Null> OnHandleTapSearch(context,center) async{
    
  }
  void setDataOrder(name, lat, lng){
    _orderService.setDataOrder(name, lat, lng);
  }
}
