class Package{
  int id;
  String name;
  int harga;
  int harga_km;
  int harga_jam;
  int harga_addkm;
  int harga_addmenit;
  int type;
  int status;

  Package({this.id,this.name,this.harga,this.harga_km,this.harga_jam,this.harga_addkm,this.harga_addmenit,this.type,this.status});

  factory Package.fromJson(Map<String, dynamic> json){
    return new Package(
      name: json['name'],
      harga: json['harga'],
      harga_km: json['harga_km'],
      harga_jam: json['harga_jam'],
      harga_addkm: json['harga_addkm'],
      harga_addmenit: json['harga_addmenit'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["harga"] = harga;
    map['harga_km'] = harga_km;
    map['harga_jam'] = harga_jam;
    map['harga_addkm'] = harga_addkm;
    map['harga_addmenit'] =  harga_addmenit;
    return map;
  }

}