import 'dart:convert';

import 'package:ajudafio_mobile/core/error/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthRemoteDataResource {
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataResourceImpl implements AuthRemoteDataResource {
  AuthRemoteDataResourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String _baseUrl =
      dotenv.env['BASE_URL'] ?? 'http://localhost:8080';

  @override
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    if (response.statusCode != 201) {
      throw ServerException(_extractMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = body['access_token'] as String?;
    if (accessToken == null) {
      throw ServerException(
        'Register response did not include an access token.',
      );
    }
    return accessToken;
  }

  @override
  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw ServerException(_extractMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final accessToken = body['access_token'] as String?;
    if (accessToken == null) {
      throw ServerException('Login response did not include an access token.');
    }
    return accessToken;
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
