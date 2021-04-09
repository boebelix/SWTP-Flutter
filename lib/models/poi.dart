import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/models/user.dart';

class Poi {
  User author;
  Category category;
  String createDate;
  String description;
  int poiId;
  Position position;
  String title;

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
      title: json['title']);
}
