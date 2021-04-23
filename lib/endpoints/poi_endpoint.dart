import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/category.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/models/position.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/models/comment.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<List<Poi>> getPoiForUser(int userId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/pois", {
          "author": "$userId",
        }),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<Poi> pois = [];

        for (dynamic content in jsonDecode(response.body)) {
          pois.add(Poi.fromJSON(content));
        }
        return pois;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNotFound'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseNoAccess'));
      } else {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Image> getPoiImage(int poiId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/pois/$poiId/image"),
        headers: {
          "content-type": "image/jpeg",
          "accept": "*/*",
          "Authorization": "Bearer ${userService.token}",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return Image.memory(response.bodyBytes);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNoImageAvailable'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseNoAccess'));
      } else {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<List<Comment>> getCommentsForPoi(int poiId) async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/pois/$poiId/comments"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}",
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<Comment> comments = [];

        for (dynamic content in jsonDecode(response.body)) {
          comments.add(Comment.fromJson(content));
        }
        return comments;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responsePoiNotFound'));
      } else {
        throw Failure(FailureTranslation.text('responseUnknownError'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Comment> createCommentForPoi(int poiId, String comment) async {
    try {
      final response = await http.post(Uri.http(url, "/api/comments/"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer ${userService.token}"
          },
          body: jsonEncode(<String, String>{
            "comment": "$comment",
            "authorId": "${userService.user.userId}",
            "poiId": "$poiId",
          }));

      if (response.statusCode == HttpStatus.ok) {
        return Comment.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.internalServerError) {
        throw Failure(FailureTranslation.text('responsePoiIdInvalid'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      } else {
        throw Failure(FailureTranslation.text('responseUnknownError'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.http(url, "/api/categories"),
        headers: {
          "content-type": "application/json; charset=utf-8",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        List<Category> categories = [];

        for (dynamic content in jsonDecode(utf8.decode(response.bodyBytes))) {
          categories.add(Category.fromJSON(content));
        }
        return categories;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseNotFound'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseNoAccess'));
      } else {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<Poi> createPoi(int categoryId, String title, String description, Position position) async {
    try {
      final response = await http.post(Uri.http(url, "/api/pois"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer ${userService.token}"
          },
          body: jsonEncode(<String, dynamic>{
            "position": {"latitude": position.latitude, "longitude": position.longitude},
            "title": title,
            "description": description,
            "authorId": AuthService().user.userId,
            "categoryId": categoryId,
          }));

      if (response.statusCode == HttpStatus.ok) {
        return Poi.fromJSON(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseCategoryIDInvalid'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      } else {
        throw Failure(FailureTranslation.text('responseUnknownError'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }

  Future<void> uploadImage(File image, Poi poi) async {
    try {
      var bytesImage = image.readAsBytesSync();

      final response = await http.post(
        Uri.http(url, "/api/pois/${poi.poiId}/image"),
        headers: {
          "content-type": "image/jpeg",
          "accept": "application/json",
          "Authorization": "Bearer ${userService.token}"
        },
        body: bytesImage,
      );

      if (response.statusCode == HttpStatus.ok) {
        return Poi.fromJSON(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw Failure(FailureTranslation.text('responseCategoryIDInvalid'));
      }

      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure(FailureTranslation.text('responseUserInvalid'));
      } else {
        throw Failure(FailureTranslation.text('responseUnknownError'));
      }
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }
}
