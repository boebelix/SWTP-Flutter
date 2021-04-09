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
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(S.of(context).groups,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  Expanded(
                    flex: 18,
                    child: ListView.builder(
                    padding:
                    const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 0),
                    itemCount: _groupService.groups.length,
                    itemBuilder: (context, index) => Dismissible(
                    onDismissed: (direction) => {
                    setState(() {
                    context.read<Cart>().remove(index);
                    })
                    },
                    key: UniqueKey(),
                    child: PizzaCartSummary(
                    pizza: pizzas[index],
                    ),
                    ),
                    shrinkWrap: true,
                    ),
                  )
                ],
              ))
        ]);
  }
}
