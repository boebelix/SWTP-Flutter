import 'package:swtp_app/models/poi.dart';

class PoiService {
  static final PoiService _instance = PoiService._internal();

  factory PoiService() => _instance;

  PoiService._internal();

  List<Poi> pois = [];
}
