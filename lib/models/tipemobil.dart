class TipeMobil{
  int id;
  String name;
  String imgUrl;

  TipeMobil({this.id,this.name,this.imgUrl});

  TipeMobil.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['imgUrl'] != null),
        id = map['id'],
        name = map['name'],
        imgUrl = map['imgUrl'];
}