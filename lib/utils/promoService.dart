import 'dart:async';
import '../models/promo.dart';
import '../data/rest_ds.dart';
class PromoService{
  RestDatasource _api;
  PromoService({RestDatasource api}){
    _api = api;
  }

  StreamController<List<Promo>> promoController = StreamController<List<Promo>>();
  Stream<List<Promo>> get promo => promoController.stream;

  Future<void> getPromo() async{
    var fetch = await _api.getPromo();
    promoController.add(fetch);
  }
}