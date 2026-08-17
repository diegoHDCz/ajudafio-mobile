import 'dart:convert';

import 'package:ajudafio_mobile/core/error/exceptions.dart';
import 'package:ajudafio_mobile/core/secrets/app_secret.dart';
import 'package:ajudafio_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteDataResource {
  Future<AuthTokenModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<AuthTokenModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthTokenModel> refresh(String refreshToken);
}

class AuthRemoteDataResourceImpl implements AuthRemoteDataResource {
  AuthRemoteDataResourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String _baseUrl = AppSecret.baseUrl;

  @override
  Future<AuthTokenModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/register');
    _logRequest(uri, {'name': name, 'email': email, 'phone': phone});
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );
    _logResponse(uri, response);

    return _parseTokenResponse(response, expectedStatusCode: 201);
  }

  @override
  Future<AuthTokenModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    _logRequest(uri, {'email': email});
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    _logResponse(uri, response);

    return _parseTokenResponse(response, expectedStatusCode: 200);
  }

  @override
  Future<AuthTokenModel> refresh(String refreshToken) async {
    final uri = Uri.parse('$_baseUrl/auth/refresh');
    _logRequest(uri, const {'refresh_token': '<redacted>'});
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );
    _logResponse(uri, response);

    return _parseTokenResponse(response, expectedStatusCode: 200);
  }

  void _logRequest(Uri uri, Map<String, dynamic> body) {
    if (!kDebugMode) return;
    debugPrint('[Auth] --> POST $uri body=${jsonEncode(body)}');
  }

  void _logResponse(Uri uri, http.Response response) {
    if (!kDebugMode) return;
    debugPrint(
      '[Auth] <-- ${response.statusCode} $uri body=${response.body}',
    );
  }

  AuthTokenModel _parseTokenResponse(
    http.Response response, {
    required int expectedStatusCode,
  }) {
    if (response.statusCode != expectedStatusCode) {
      throw ServerException(_extractMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['access_token'] == null || body['refresh_token'] == null) {
      throw ServerException('Response did not include the expected tokens.');
    }
    return AuthTokenModel.fromApiJson(body);
  }

  String _extractMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is String) return decoded;
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {
      // Response body wasn't JSON we could parse; fall through to default.
    }
    return 'Request failed with status ${response.statusCode}.';
  }
}
