class AuthTokenModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthTokenModel.fromApiJson(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int;
    return AuthTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
    );
  }

  factory AuthTokenModel.fromStorageJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  /// Treats the token as expired slightly before its real expiry to avoid
  /// racing a request against the server-side clock.
  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(seconds: 10)));
}
