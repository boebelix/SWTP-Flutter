import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<String> getPoiForUser(int userId) async {
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
        return response.body;
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
      throw Failure("Unknown Error Occured");
    } on SocketException {
      throw Failure(FailureTranslation.text('noConnection'));
    } on HttpException {
      throw Failure(FailureTranslation.text('httpRestFailed'));
    } on FormatException {
      throw Failure(FailureTranslation.text('parseFailure'));
    }
  }
}
