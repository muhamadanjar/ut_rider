import 'package:flutter/widgets.dart';

import 'place_item_res.dart';
class Order{
  String origin;
  String destination;
  double originLat;
  double originLng;
  double destinationLat;
  double destinationLng;
  int harga;
  int typeOrder;
  int duration;
  int distance;
  int bookBy;
  Order({
      this.origin,
      this.destination,
      this.originLat,
      this.originLng,
      this.destinationLat,
      this.destinationLng,
      this.harga,
      this.typeOrder,
      this.duration,
      this.distance,
      this.bookBy,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        origin: json['origin'],
        destination: json['destination'],
        originLat: json['originLat'],
        originLng: json['originLng'],
        destinationLat: json['destinationLat'],
        destinationLng: json['destinationLng'],
        harga: json['harga'],
        typeOrder: json['typeOrder'],
        duration: json['duration'],
        distance: json['distance'],
    );
  }
  factory Order.initialData() {
    return Order(
      origin: '',
      destination: '',
      originLng: null,
      originLat:null,
      destinationLat: null,
      destinationLng:null,
      harga: 0,
      typeOrder: 0,
      duration: 0,
      distance: 0,
    );
  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["origin"] = origin;
    map["destination"] = destination;
    map['originLat'] = originLat;
    map['originLng'] = originLng;
    map['destinationLat'] = destinationLat;
    map['destinationLng'] =  destinationLng;
    map["harga"] = harga;
    map["typeOrder"] = typeOrder;
    map["duration"] = duration;
    map["distance"] = distance;
    return map;
  }

  Map<String, dynamic> toMapDatabase() {
    var map = new Map<String, dynamic>();
    map["trip_address_origin"] = origin;
    map["trip_address_destination"] = destination;
    map['trip_or_origin'] = originLat;
    map['trip_or_longitude'] = originLng;
    map['trip_des_latitude'] = destinationLat;
    map['trip_des_longitude'] =  destinationLng;
    map["trip_total"] = harga;
    map["typeOrder"] = typeOrder;
    map["duration"] = duration;
    map["distance"] = distance;
    map['trip_job'] = 4;
    map['trip_bookby'] = bookBy;
    map['rent_package'] = 1;
    return map;
  }

}

class OrderPemesanan with ChangeNotifier{
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  OrderPemesanan({this.fromAddress,this.toAddress});

  setFrom(PlaceItemRes res){
    this.fromAddress = res;
    notifyListeners();
  }

  setTo(PlaceItemRes res){
    this.toAddress = res;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["origin"] = fromAddress;
    map["destination"] = toAddress;
    return map;
  }
}

class Booking {
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  int statusBooking = 0;
  Booking({this.fromAddress,this.toAddress,this.statusBooking});
}