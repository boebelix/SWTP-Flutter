import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/properties/properties.dart';
import 'package:swtp_app/services/auth_service.dart';

class PoiEndpoint {
  var url = Properties.url;
  AuthService userService = AuthService();

  Future<List<Poi>> getPoiForUser(int userId) async {
    return await http
        .get(Uri.http(url, "/api/pois", {"author": "$userId"}), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      "Authorization": "Bearer ${userService.token}"
    }).then((response) {
      if (response.statusCode == HttpStatus.ok) {
        List<Poi> pois = [];
        for (dynamic content in jsonDecode(response.body)) {
          pois.add(Poi.fromJSON(content));
        }
        return pois;
      } else {
        if (response.statusCode == HttpStatus.notFound) {
          throw Failure("not found");
        }
        if (response.statusCode == HttpStatus.forbidden) {
          throw Failure("Access not allowed");
        }
        throw Failure("User is not valid");
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
        throw Failure("no Image available");
      }
      if (response.statusCode == HttpStatus.forbidden) {
        throw Failure("Access not allowed");
      }
      throw Failure("unknown error occured");
    });
  }
}
