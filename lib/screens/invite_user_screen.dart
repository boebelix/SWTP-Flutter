import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/widgets/loading_indicator.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class InviteUserScreen extends StatefulWidget {
  static const routeName = '/invite';

  @override
  _InviteUserScreenState createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  UserServiceProvider userProvider;
  GroupServiceProvider groupProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserServiceProvider>(context, listen: false);
    groupProvider = Provider.of<GroupServiceProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.of(context).inviteUsers),
      ),
      body: Stack(
        children: [
          Consumer<UserServiceProvider>(
            builder: (_, notifier, __) {
              switch (notifier.state) {
                case NotifierState.initial:
                  return Container();
                  break;
                case NotifierState.loading:
                  return LoadingIndicator();
                  break;
                default:
                  return notifier.allUsersResponse.fold(
                    (failure) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        notifier.resetState();
                      });
                      return PopUpWarningDialog(
                        context: context,
                        failure: failure,
                      );
                    },
                    (r) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildUserList(context),
                            TextButton(
                              onPressed: () {
                                _inviteUsers();
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: Card(
                                  color: Theme.of(context).buttonColor,
                                  elevation: 10,
                                  child: Center(child: Text(Language.of(context).invite)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
              }

              {}
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: userProvider.usersNotInOwnGroup.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(
                "${userProvider.usersNotInOwnGroup.elementAt(index).firstName} ${userProvider.usersNotInOwnGroup.elementAt(index).lastName}"),
            tristate: false,
            value: userProvider.isUserChosen(index),
            onChanged: (newValue) {
              setState(() {
                userProvider.chooseUser(index, newValue);
              });
            },
          );
        });
  }

  _inviteUsers() async {
    for (User user in userProvider.usersToInvite) {
      await groupProvider.inviteUserToGroup(user.userId);
    }
    await userProvider.getAllUsers(groupProvider.ownGroup);

    Navigator.pop(context);
  }
}
