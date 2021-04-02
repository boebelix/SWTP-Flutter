import 'package:flutter/material.dart';

class User {
  int userId;
  String userName;
  String firstName;
  String lastName;
  String email;
  String city;
  String street;
  String streetNr;
  String zip;

  User(
      {this.userId,
      this.userName,
      this.firstName,
      this.lastName,
      this.email,
      this.city,
      this.street,
      this.streetNr,
      this.zip});

  factory User.fromJSON(Map<String, dynamic> json) => User(
        userId: json['userId'],
        userName: json['username'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        email: json['email'],
        city: json['city'],
        street: json['street'],
        streetNr: json['streetNr'],
        zip: json['zip'],
      );

  @override
  String toString() {
    return 'User{userId: $userId, userName: $userName, firstName: $firstName, lastName: $lastName, email: $email, city: $city, street: $street, streetNr: $streetNr, zip: $zip}';
  }
/*
  Map<String, dynamic> toJSON() =>{
    "username":userName,
    "firstname": firstName,
    "lastname": lastName,
    "email": email,

  }

 */

}
