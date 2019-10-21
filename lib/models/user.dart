import 'package:flutter/material.dart';

class User {
  final String email;
  final String username;
  final String password;
  final String name;
  String token;
  final double rating;
  final int trip;
  String saldo;
  String address;
  String phoneNumber;
  final String photoUrl;
  String randomUrl = 'https://i.pravatar.cc/200';
  User({
    @required this.email,
    this.username,
    this.password,
    @required this.token,
    @required this.name,
    this.rating,
    this.trip,
    this.saldo,
    this.photoUrl,
    this.randomUrl,
    this.phoneNumber,
    this.address
  });

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
      randomUrl: 'https://i.pravatar.cc/200', 
      email: json['email']

    );
  }

  factory User.initialData(Map<String,dynamic> json){
    return User(name: 'A',token: 'A',email: 'A', randomUrl: 'https://i.pravatar.cc/200');
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