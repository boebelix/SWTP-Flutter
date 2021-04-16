import 'package:flutter/material.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/models/comment.dart';

class Poi {
  User author;
  Category category;
  String createDate = "";
  String description = "";
  int poiId;
  Position position;
  String title = "";
  Image image;
  List<Comment> comments;

  Poi(
      {this.author,
      this.category,
      this.createDate,
      this.description,
      this.poiId,
      this.position,
      this.title});

  factory Poi.fromJSON(Map<String, dynamic> json) => Poi(
        author: User.fromJSON(json['author']),
        category: Category.fromJSON(json['category']),
        createDate: json['createDate'],
        description: json['description'],
        poiId: json['poiId'],
        position: Position.fromJSON(json['position']),
        title: json['title'],
      );

  @override
  String toString() {
    return 'Poi{author: ${author.toString()}, category: ${category.toString()}, createDate: $createDate, description: $description, poiId: $poiId, position: ${position.toString()}, title: $title}';
  }
}
