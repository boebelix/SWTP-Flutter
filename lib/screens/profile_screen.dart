import 'package:flutter/material.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

GroupService _groupService = GroupService();

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{

  AuthService _authService = AuthService();
  GroupService _groupService=GroupService();

  TabController _controller;

  @override
  void initState()
  {
    super.initState();
    _controller=TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("${_authService.user.firstName} ${_authService.user.lastName}",
         style: TextStyle(
           fontSize: 20.0,
           fontWeight: FontWeight.bold,
         )),
      ),
      TabBar(tabs: [Tab(text: _groupService.ownGroup.groupName), Tab(text: Language.of(context).ownPOI)], controller: _controller,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black12,),
    ]);
  }
}
