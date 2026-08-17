import 'dart:convert';

import 'package:ajudafio_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokenModel tokens);
  Future<AuthTokenModel?> getTokens();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  static const _tokensKey = 'auth_tokens';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveTokens(AuthTokenModel tokens) {
    return _storage.write(
      key: _tokensKey,
      value: jsonEncode(tokens.toStorageJson()),
    );
  }

  @override
  Future<AuthTokenModel?> getTokens() async {
    final raw = await _storage.read(key: _tokensKey);
    if (raw == null) return null;
    try {
      return AuthTokenModel.fromStorageJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearTokens() {
    return _storage.delete(key: _tokensKey);
  }
}
