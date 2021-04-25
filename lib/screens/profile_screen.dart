import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swtp_app/generated/l10n.dart';
import 'package:swtp_app/providers/group_service_provider.dart';
import 'package:swtp_app/widgets/own_group_widget.dart';
import 'package:swtp_app/widgets/own_pois_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {

  TabController _controller;

  GroupServiceProvider _groupServiceProvider;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _groupServiceProvider=Provider.of<GroupServiceProvider>(context,listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height,
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
    if (_groupServiceProvider.ownGroup != null)
      return Tab(text: _groupServiceProvider.ownGroup.groupName);
    else
      return Tab(text: Language.of(context).ownGroup);
  }
}
