import 'package:ajudafio_mobile/core/utils/jwt_decoder.dart';
import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  /// Builds a [UserModel] straight from the access token's JWT claims,
  /// since the auth endpoints only return the token, not the user payload.
  factory UserModel.fromToken(String token) {
    final claims = JwtDecoder.decode(token);
    return UserModel(
      id: _claim(claims, ['sub', 'id', 'userId']) ?? '',
      name: _claim(claims, ['name', 'fullName', 'username']) ?? 'Usuário',
      email: _claim(claims, ['email']) ?? '',
      phone: _claim(claims, ['phone', 'phoneNumber']) ?? '',
    );
  }

  static String? _claim(Map<String, dynamic> claims, List<String> keys) {
    for (final key in keys) {
      final value = claims[key];
      if (value != null) return value.toString();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }
}
