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
}