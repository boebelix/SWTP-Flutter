import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/poi.dart';

class PoiService {
  static final PoiService _instance = PoiService._internal();

  factory PoiService() => _instance;

  PoiService._internal();

  PoiEndpoint _poiEndpoint = PoiEndpoint();
  List<Poi> pois = [];

  Future<void> getAllVisiblePois(List<int> userIds) async {
    pois.clear();
    for (int i in userIds) {
      String response = await _poiEndpoint.getPoiForUser(i);
      for (dynamic content in jsonDecode(response)) {
        pois.add(Poi.fromJSON(content));
      }
    }
    for (Poi i in pois) {
      i.image = await _poiEndpoint.getPoiImage(i.poiId);
    }
  }
}
