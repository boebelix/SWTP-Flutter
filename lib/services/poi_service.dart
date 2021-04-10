import 'dart:convert';

import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/poi.dart';

class PoiService {
  static final PoiService _instance = PoiService._internal();

  factory PoiService() => _instance;

  PoiService._internal();

  PoiEndpoint _poiEndpoint = PoiEndpoint();
  List<Poi> pois = List<Poi>();

  Future<void> getAllVisiblePois(List<int> userIds) async {
    pois.clear();
    for (int i in userIds) {
      String response = await _poiEndpoint.getPoiForUser(i);
      for (dynamic content in jsonDecode(response)) {
        pois.add(Poi.fromJSON(content));
      }
    }
  }
}
