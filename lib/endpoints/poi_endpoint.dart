import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/log_service.dart';
import 'package:swtp_app/models/comment.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();
  LogService logService = LogService();

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

        logService.prettyLogger.d(jsonDecode(response.body));

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
}
