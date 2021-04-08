import 'package:swtp_app/endpoints/login_endpoint.dart';
import 'package:swtp_app/endpoints/register_endpoint.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/models/register_credentials.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  User _user;
  String _token;

  void logIn(LoginCredentials credentials) async {
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

  void registerUser({RegisterCredentials credentials}) async {
    Map<String, dynamic> responseData =
        await RegisterEndpoint().register(credentials);
    _user = User.fromJSON(responseData);
  }

  String get token=> _token;
  User get user => _user;
}