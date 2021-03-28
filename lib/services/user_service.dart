import 'package:swtp_app/endpoints/LogInEndpoint.dart';
import 'package:swtp_app/models/Credentials.dart';
import 'package:swtp_app/models/User.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  User _user;
  String _token;

  void logIn(Credentials credentials) async {
    Map<String, dynamic> responseData =
        await LogInEndpoint().signIn(credentials);
    _user = User.fromJSON(responseData['user']);
    _token = responseData['token'];
  }

  void logOut() {
    _user = null;
    _token = null;
  }

  bool isSignedIn() {
    return _token != null && _user != null;
  }

  User get user => _user;
}
