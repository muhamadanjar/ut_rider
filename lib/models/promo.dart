class Promo {
  String name;
  String kode_promo;
  String description;
  int discount;
  String imgUrl;
  Promo({this.name,this.kode_promo,this.discount,this.imgUrl,this.description});

  factory Promo.fromMap(Map json){
    return new Promo(name: json['name'],kode_promo: json['kode_promo'],discount: json['discount'],imgUrl: json['imgUrl']);
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["kode_promo"] = kode_promo;
    map['discount'] = discount;
    return map;
  }
}