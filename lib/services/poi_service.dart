import 'dart:convert';

import 'package:swtp_app/endpoints/poi_endpoint.dart';
import 'package:swtp_app/models/poi.dart';

class PoiService {
  static final PoiService _instance = PoiService._internal();

  factory PoiService() => _instance;

  PoiService._internal();

  PoiEndpoint _poiEndpoint = PoiEndpoint();
  List<Poi> Pois = List<Poi>();

  void getAllVisiblePois(List<int> userIds) async {
    Pois.clear();
    for (int i in userIds) {
      String response = await _poiEndpoint.getPoiForUser(i);
      for (dynamic e in jsonDecode(response)) {
        Pois.add(Poi.fromJSON(e));
      }
    }
    print(Pois.toString());
  }
}
