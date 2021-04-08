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

  Either<Failure, AuthResponse> _authResponse;

  // ----------------------------------------------------

  NotifierState get state => _state;

  Either<Failure, AuthResponse> get authResponse => _authResponse;

  User get user => _user;

  void reset() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void _setAuthResponse(Either<Failure, AuthResponse> authResponse) {
    if (authResponse.isRight()) {
      final tmp = authResponse.getOrElse(null);
      _user = tmp.user;
      _token = tmp.token;
    }
    _authResponse = authResponse;
    notifyListeners();
  }

  void logIn(LoginCredentials credentials) async {
    _setState(NotifierState.loading);

    await Task(() => LogInEndpoint().signIn(credentials))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAuthResponse(value));

    _setState(NotifierState.loaded);
  }

  void logOut() {
    print('userService: logOut');
    _user = null;
    _token = null;
    _authResponse = null;
    _setState(NotifierState.initial);
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
}
