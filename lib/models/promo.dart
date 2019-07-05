class Promo {
  String name;
  String kodePromo;
  String description;
  int discount;
  String imgUrl;
  Promo({this.name,this.kodePromo,this.discount,this.imgUrl,this.description});

  factory Promo.fromMap(Map json){
    return new Promo(name: json['name'],kodePromo: json['kode_promo'],discount: json['discount'],imgUrl: json['imgUrl']);
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["kode_promo"] = kodePromo;
    map['discount'] = discount;
    return map;
  }
}