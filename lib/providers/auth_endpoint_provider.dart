import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:swtp_app/endpoints/auth_endpoint.dart';
import 'package:swtp_app/models/auth_response.dart';
import 'package:swtp_app/models/failure.dart';
import 'package:swtp_app/models/login_credentials.dart';
import 'package:swtp_app/services/auth_service.dart';
import 'package:swtp_app/services/information_pre_loader_service.dart';

enum NotifierState { initial, loading, loaded }

class AuthEndpointProvider extends ChangeNotifier {
  static final AuthEndpointProvider _instance =
      AuthEndpointProvider._internal();

  factory AuthEndpointProvider() => _instance;

  AuthEndpointProvider._internal();

  AuthService _authService = AuthService();
  AuthEndpoint _logInEndpoint = AuthEndpoint();
  NotifierState _state = NotifierState.initial;
  Either<Failure, AuthResponse> _authResponse;
  InformationPreLoaderService informationPreLoaderService =
      InformationPreLoaderService();

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

  void _setAuthResponse(Either<Failure, AuthResponse> authResponse) async {
    if (authResponse.isRight()) {
      final tmp = authResponse.getOrElse(null);

      _authService.token = tmp.token;
      _authService.user = tmp.user;
      await informationPreLoaderService.loadAllInformation();
    }

    _authResponse = authResponse;

    notifyListeners();
  }

  Future<void> logIn(LoginCredentials credentials) async {
    setState(NotifierState.loading);

    await Task(() => _logInEndpoint.signIn(credentials))
        .attempt()
        .mapLeftToFailure()
        .run()
        .then((value) => _setAuthResponse(value));

    _state = NotifierState.loaded;
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
