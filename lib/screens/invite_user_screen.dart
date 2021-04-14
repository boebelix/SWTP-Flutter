// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class UserScreen extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     //UserService _userService=UserService();
//     return FutureBuilder<void>(
//       //future: _userService.getAllUser(),
//       builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//         List<Widget> children;
//         if (snapshot.connectionState == ConnectionState.done) {
//           children = <Widget>[
//             _buildUserList();
//           ];
//         } else if (snapshot.hasError) {
//           children = <Widget>[
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 60,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 16),
//               child: Text('Error: ${snapshot.error}'),
//             )
//           ];
//         } else {
//           children = const <Widget>[
//             SizedBox(
//               child: CircularProgressIndicator(),
//               width: 60,
//               height: 60,
//             ),
//           ];
//         }
//         return Center(
//           child: Column(
//             children: children,
//           ),
//         );
//       },
//     );
//   }
//
//   ListView _buildUserList() {
//     return ListView.builder(
//         padding: EdgeInsets.all(5),
//         shrinkWrap: true,
//         scrollDirection: Axis.vertical,
//         itemCount: _userService.allUsersNotInGroup.length,
//         itemBuilder: (context, index) {
//           CheckboxListTile(
//             title: Text(_userService.allUsersNotInGroup_userService.allUsersNotInGroup.name),
//             tristate: false,
//             value: _labelCheckedMap[key],
//             onChanged: (newValue) {
//               setState(() {
//                 _labelCheckedMap.update(key, (value) => newValue);
//               });
//             },
//           )
//         });
//   }
// }
