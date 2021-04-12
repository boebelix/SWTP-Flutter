import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<String> getPoiForUser(int userId) async {
    return await http
        .get(Uri.http(url, "/api/pois", {"author": "$userId"}), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      } else {
        if (response.statusCode == HttpStatus.notFound) {
          throw HttpException("not found");
        }
        if (response.statusCode == HttpStatus.forbidden) {
          throw HttpException("Access not allowed");
        }
        throw HttpException("User is not valid");
      }
    });
  }

  Future<Image> getPoiImage(int poiId) async {
    return await http.get(Uri.http(url, "/api/pois/$poiId/image"), headers: {
      "content-type": "image/jpeg",
      "accept": "*/*",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        return Image.memory(response.bodyBytes);
      }
      //wenn der Poi kein Bild hat kommt ein 404 zurück => handling?
      if (response.statusCode == HttpStatus.notFound) {
        return null;
      }
      if (response.statusCode == HttpStatus.forbidden) {
        throw HttpException("Access not allowed");
      }
      return null;
    });
  }
}
