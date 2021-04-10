import 'package:swtp_app/models/group.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/models/poi.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/services/poi_service.dart';

class InformationPreLoaderService{
  GroupService groupService= GroupService();
  PoiService poiService=PoiService();

  Future<void> loadAllInformation() async{
    await groupService.reloadAll();
    List<Group> acceptedGroups=groupService.acceptedGroups;
    List<int> userIds=List<int>();
    userIds.add(AuthService().user.userId);
    for(Group group in acceptedGroups){
      userIds.add(group.admin.userId);
    }
    await poiService.getAllVisiblePois(userIds);
  }
}