import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/l10n/failure_translation.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/group_membership.dart';
import 'package:swtp_app/providers/user_service_provider.dart';
import 'package:swtp_app/screens/invite_user_screen.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/widgets/warning_dialog.dart';

class OwnGroupWidget extends StatefulWidget {
  @override
  _OwnGroupState createState() => _OwnGroupState();
}

class _OwnGroupState extends State<OwnGroupWidget> {
  GroupService _groupService = GroupService();
  final TextEditingController _groupNameTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _groupService.loadOwnGroup(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_groupService.ownGroup != null) {
            return buildOwnGroupWidget();
          } else {
            return buildOwnGroupNonExistentWidget();
          }
        } else if (snapshot.hasError) {
          return PopUpWarningDialog(context: context, failure: Failure(FailureTranslation.text('ownGroupLoadFailed')));
        } else {
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        }
      },
    );
  }

  Widget buildOwnGroupNonExistentWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: Language.of(context).ownGroup,
            ),
            controller: _groupNameTextController,
            validator: _validatorGroupnameIsNotEmpty,
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
              child: TextButton(
                onPressed: () => setState(() {
                  _createGroupWithName();
                }),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Card(
                    color: Theme.of(context).buttonColor,
                    elevation: 10,
                    child: Center(child: Text(Language.of(context).create)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOwnGroupWidget() {
    return Column(
      children: [
        _buildMemberText(context),
        Expanded(
          child: _buildListViewAcceptedMembersOfOwnGroup(),
        ),
        _buildInvitedText(context),
        Expanded(
          child: _buildListViewOfInvitedMembersOfOwnGroup(),
        ),
        Align(
          alignment: FractionalOffset.bottomLeft,
          child: _createInviteUserButton(),
        ),
      ],
    );
  }

  Widget _createInviteUserButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              _showInvitationScreen(context);
              Navigator.pushNamed(context, InviteUserScreen.routeName);
            }),
      ],
    );
  }

  Padding _buildMemberText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).members,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Padding _buildInvitedText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(Language.of(context).invited,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildListViewAcceptedMembersOfOwnGroup() {
    List<GroupMembership> group = _groupService.ownGroup.memberships;
    List<GroupMembership> inGroup = group.where((element) => element.invitationPending == false).toList();

    return buildList(inGroup, true);
  }

  ListView buildList(List<GroupMembership> explicitList, bool shrink) {
    return ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: shrink,
        scrollDirection: Axis.vertical,
        itemCount: explicitList.length,
        itemBuilder: (context, index) {
          return _createMemberCard(explicitList.elementAt(index));
        });
  }

  Widget _buildListViewOfInvitedMembersOfOwnGroup() {
    List<GroupMembership> group = _groupService.ownGroup.memberships;
    List<GroupMembership> notInGroup = group.where((element) => element.invitationPending == true).toList();

    return buildList(notInGroup, false);
  }

  Card _createMemberCard(GroupMembership membership) {
    return Card(
        key: UniqueKey(),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("${membership.member.firstName} ${membership.member.lastName}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            IconButton(
                icon: Icon(Icons.person_remove_outlined),
                onPressed: () {
                  _removeUserFromGroup(membership.member.userId);
                })
          ],
        ));
  }

  Future<void> _removeUserFromGroup(int userId) async {
    await _groupService.kickUserFromOwnGroup(userId);
  }

  Future<void> _showInvitationScreen(BuildContext context) async {
    await Provider.of<UserServiceProvider>(context, listen: false).getAllUsers();
  }

  String _validatorGroupnameIsNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return Language.of(context).warning_group_name_NN;
    }

    return null;
  }

  Future<void> _createGroupWithName() async {
    if (_formKey.currentState.validate()) {
      await GroupService().createGroup(_groupNameTextController.text);
    }
    setState(() {
      _groupNameTextController.clear();
    });
  }
}
