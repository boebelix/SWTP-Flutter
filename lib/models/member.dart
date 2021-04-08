import 'package:swtp_app/models/user.dart';

class Member extends User{
  factory Member.fromJSON(Map<String, dynamic> json) =>User.fromJSON(json);
}
