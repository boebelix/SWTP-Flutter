import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:swtp_app/endpoints/login_endpoint.dart';
import 'package:swtp_app/endpoints/register_endpoint.dart';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/models/register_credentials.dart';

enum NotifierState { initial, loading, loaded }

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  User _user;

  String _token;

  NotifierState _state = NotifierState.initial;

  Either<Failure, AuthResponse> _userService;

  // ----------------------------------------------------

  NotifierState get state => _state;

  Either<Failure, AuthResponse> get userService => _userService;

  User get user => _user;

  /// Stellt den initialen Zustand wieder her. Sollte nach jedem Fehler Handling zurückgesetz werden
  void resetState() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void _parseAuthResponse(Either<Failure, AuthResponse> authResponse) {
    if (authResponse.isRight()) {
      final tmp = authResponse.getOrElse(null);
      _user = tmp.user;
      _token = tmp.token;
    }
    _userService = authResponse;
    notifyListeners();
  }

  void logIn(LoginCredentials credentials) async {
    _setState(NotifierState.loading);

    await Task(() => LogInEndpoint().signIn(credentials))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _parseAuthResponse(value));

    _setState(NotifierState.loaded);
  }

  void logOut() {
    _user = null;
    _token = null;
    _userService = null;
    resetState();
    notifyListeners();
  }

  bool isSignedIn() {
    return _token.isNotEmpty && _user != null;
  }

  void registerUser({RegisterCredentials credentials}) async {
    Map<String, dynamic> responseData =
        await RegisterEndpoint().register(credentials);
    _user = User.fromJSON(responseData);
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
  String get token=> _token;
  User get user => _user;
}
