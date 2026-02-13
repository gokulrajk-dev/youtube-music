
import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    required this.gmail,
    required this.password,
    required this.userName,
    required this.phoneNumber,
    required this.photoUrl,
  });

  final dynamic gmail;
  final dynamic password;
  final dynamic userName;
  final dynamic phoneNumber;
  final dynamic photoUrl;

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) => UserDetails(
    gmail: json["gmail"],
    password: json["password"],
    userName: json["user_name"],
    phoneNumber: json["phone_number"],
    photoUrl: json["photo_url"],
  );

  Map<dynamic, dynamic> toJson() => {
    "gmail": gmail,
    "password": password,
    "user_name": userName,
    "phone_number": phoneNumber,
    "photo_url": photoUrl,
  };
}


