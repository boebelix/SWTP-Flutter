import 'package:flutter/material.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/services/group_service.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = '/groups';

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  GroupService _groupService = GroupService();

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Text(S.of(context).groups,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ))
              ]))
        ]);
  }
}
