import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/user_endpoint_provider.dart';

class InviteUserScreen extends StatefulWidget {
  static const routeName = '/invite';

  @override
  _InviteUserScreenState createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  UserEndpointProvider userprovider;

  @override
  Widget build(BuildContext context) {
    userprovider = Provider.of<UserEndpointProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
        title: Text(Language.of(context).inviteUsers),
    ),
    body: Column(
      children: [
        _buildUserList(context),

      ],
    ),


    );
  }

  Widget _buildUserList(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: userprovider.usersNotInOwnGroup.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
                "${userprovider.usersNotInOwnGroup.elementAt(index).firstName} ${userprovider.usersNotInOwnGroup.elementAt(index).lastName}"),
            tristate: false,
            value: userprovider.isUserChoosen(index),
            onChanged: (newValue) {
              userprovider.chooseUser(index, newValue);
            },
          );
        });
  }
}
