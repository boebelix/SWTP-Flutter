import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/providers/poi_endpoint_provider.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/services/poi_service.dart';


class InformationPreLoaderService {
  static final InformationPreLoaderService _instance= InformationPreLoaderService._internal();

  factory InformationPreLoaderService() => _instance;

  InformationPreLoaderService._internal();


  GroupService groupService = GroupService();
  PoiService poiService = PoiService();
  BuildContext context;

  List<int> userIds=[];

  Future<void> loadAllRelevaltUserIds() async {
    await groupService.reloadAll();
    List<Group> acceptedGroups = groupService.acceptedGroups;
    userIds.add(AuthService().user.userId);
    for (Group group in acceptedGroups) {
      userIds.add(group.admin.userId);
    }
  }
}
