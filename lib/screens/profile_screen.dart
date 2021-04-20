import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/group_service.dart';
import 'package:swtp_app/widgets/own_group_widget.dart';
import 'package:swtp_app/widgets/own_pois_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {

  TabController _controller;

  GroupServiceProvider groupServiceProvider;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    groupServiceProvider=Provider.of<GroupServiceProvider>(context,listen: false);
    final deviceSice = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSice.height,
      child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              tabs: [
                createOwnGroupTextTab(),
                Tab(text: Language.of(context).ownPOI)
              ],
              controller: _controller,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black12,
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  OwnGroupWidget(),
                  OwnPOIWidget(),
                ],
              ),
            )
          ]),
    );
  }

  Tab createOwnGroupTextTab() {
    if (groupServiceProvider.ownGroup != null)
      return Tab(text: groupServiceProvider.ownGroup.groupName);
    else
      return Tab(text: Language.of(context).ownGroup);
  }
}
