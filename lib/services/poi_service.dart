import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/providers/poi_endpoint_provider.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'information_pre_loader_service.dart';

class PoiService {
  static final PoiService _instance = PoiService._internal();

  factory PoiService() => _instance;

  PoiService._internal();

  AuthService authService = AuthService();

  List<Poi> pois = [];

  Future loadPoisAfterSuccesfullAuthentication(BuildContext context) async {
    if (await authService.isSignedIn()) {
      var allUserIdsOfMembershipsOwner = await InformationPreLoaderService().userIds;
      var poiEndpointProvider = await Provider.of<PoiEndpointProvider>(context, listen: false);
      await poiEndpointProvider.getAllVisiblePois(allUserIdsOfMembershipsOwner);
    }
  }
}
