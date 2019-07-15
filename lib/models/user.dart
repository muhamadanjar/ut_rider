class User {
  final String username;
  final String password;
  final String name;
  String token;
  final double rating;
  final int trip;
  String saldo;
  User({this.username, this.password,this.token,this.name,this.rating,this.trip,this.saldo});

  String get getUsername => username;
  String get getName => name;

  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      rating: json['rating'],
      trip: json['trip'],
      token: json['token'],
      saldo: json['wallet'],
    );
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["name"] = password;
    map["password"] = password;
    map['token'] = token;

    return map;
  }

}