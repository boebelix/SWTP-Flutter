import 'package:swtp_app/models/user.dart';

class AuthResponse {
  String token;
  User user;

  AuthResponse({this.token, this.user});

  factory AuthResponse.fromJSON(Map<String, dynamic> json) => AuthResponse(
        token: json['token'],
        user: User.fromJSON(json['user']),
      );

  Map<String, dynamic> toJSON() => {
        "token": token,
        "user": user,
      };

  @override
  String toString() {
    return 'AuthResponse{token: $token, user: $user}';
  }
}
