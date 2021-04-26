import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swtp_app/endpoints/auth_endpoint.dart';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/models/notifier_state.dart';
import 'package:swtp_app/models/user.dart';
import 'package:swtp_app/services/auth_service.dart';

class AuthEndpointProvider extends ChangeNotifier {
  static final AuthEndpointProvider _instance = AuthEndpointProvider._internal();

  static final storage = FlutterSecureStorage();

  factory AuthEndpointProvider() => _instance;

  AuthEndpointProvider._internal();

  AuthService _authService = AuthService();
  AuthEndpoint logInEndpoint = AuthEndpoint();
  NotifierState _state = NotifierState.initial;
  Either<Failure, AuthResponse> _authResponse;

  Either<Failure, User> get reloadUserResponse => _reloadUserResponse;
  Either<Failure, User> _reloadUserResponse;

  NotifierState get state => _state;

  void setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  void resetState() {
    _state = NotifierState.initial;
    notifyListeners();
  }

  Either<Failure, AuthResponse> get authResponse => _authResponse;

  void _setAuthResponse(Either<Failure, AuthResponse> authResponse) {
    if (authResponse.isRight()) {
      final tmp = authResponse.getOrElse(null);

      _authService.token = tmp.token;
      storage.write(key: 'token', value: _authService.token);
      _authService.user = tmp.user;
      storage.write(key: 'userId', value: _authService.user.userId.toString());
    }

    _authResponse = authResponse;

    notifyListeners();
  }

  Future<void> logIn(LoginCredentials credentials) async {
    setState(NotifierState.loading);

    await Task(() => logInEndpoint.signIn(credentials))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAuthResponse(value));

    _state = NotifierState.loaded;
  }

  Future<void> checkIfAlreadyLoggedInAndLoadUser(int userId) async {
    setState(NotifierState.loading);
    await Task(() => _logInEndpoint.getUserById(userId))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setUserResponse(value));

    setState(NotifierState.loaded);
  }

  _setUserResponse(Either<Failure, User> response) {
    if (response.isRight()) {
      _authService.user = response.getOrElse(() => null);
    }
    _reloadUserResponse = response;
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
