class Package{
  int id;
  String name;
  int harga;
  int hargaKm;
  int hargaJam;
  int hargaAddKm;
  int hargaAddMenit;
  int type;
  int status;
  String imgUrl;

  Package({this.id,this.name,this.harga,this.hargaKm,this.hargaJam,this.hargaAddKm,this.hargaAddMenit,this.type,this.status,this.imgUrl});

  factory Package.fromJson(Map<String, dynamic> json){
    return new Package(
      name: json['name'],
      harga: json['harga'],
      hargaKm: json['harga_km'],
      hargaJam: json['harga_jam'],
      hargaAddKm: json['harga_addkm'],
      hargaAddMenit: json['harga_addmenit'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["harga"] = harga;
    map['harga_km'] = hargaKm;
    map['harga_jam'] = hargaJam;
    map['harga_addkm'] = hargaAddKm;
    map['harga_addmenit'] =  hargaAddMenit;
    map["imgUrl"] = imgUrl;
    return map;
  }

}