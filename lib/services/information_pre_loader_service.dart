import 'package:flutter/material.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/services/poi_service.dart';

class InformationPreLoaderService {
  static final InformationPreLoaderService _instance = InformationPreLoaderService._internal();

  factory InformationPreLoaderService() => _instance;

  InformationPreLoaderService._internal();

  GroupService groupService = GroupService();
  PoiService poiService = PoiService();
  BuildContext context;

  /// Alle NutzerIds der Admins von allen angehörigen Gruppen
  List<int> userIds = [];

  Future<void> loadAllRelevantUserIds() async {
    userIds.clear();

    // Beim Registrien ist noch keine Gruppe vorhanden. Dies führt zu einem
    // Fehler beim Aufrufen der Gruppe, der im Grunde nicht gravierend ist.
    // Es ist der Normalzustand nach dem Registrien, da noch keine Gruppe
    // angelegt ist.
    try {
      await groupService.reloadAll();
    } catch (e) {
      if (FailureTranslation.text('groupNotFound') != e.toString()) {
        throw Failure('${FailureTranslation.text('unknownFailure')} ${e.toString()}');
      }
    }

    List<Group> acceptedGroups = groupService.acceptedGroups;

    //Eigene Gruppe der Liste hinzufügen
    userIds.add(AuthService().user.userId);

    //Alle anderen Gruppen denen der Nutzer angehört hinzufügen
    for (Group group in acceptedGroups) {
      userIds.add(group.admin.userId);
    }
  }
}
