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
}
