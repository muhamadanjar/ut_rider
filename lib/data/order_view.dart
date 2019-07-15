import 'package:flutter/widgets.dart';
import 'package:ut_order/utils/order.service.dart';
import '../models/base_model.dart';

class OrderViewModel extends BaseModel {
  OrderService _orderService;

  OrderViewModel({
    @required OrderService orderService,
  }) : _orderService = orderService;

}
