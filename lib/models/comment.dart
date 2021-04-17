import 'package:swtp_app/models/user.dart';

class Comment {
  User author;
  String comment;
  int commentId;
  String createDate;

  Comment({this.author, this.comment, this.commentId, this.createDate});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    author: User.fromJSON(json['author']),
    comment: json['comment'],
    commentId: json['commentId'],
    createDate: json['createDate'],
  );
}