import 'package:ajudafio_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:http/http.dart' as http;

/// An [http.Client] that attaches `Authorization: Bearer <token>` to every
/// request, refreshing the session (via [AuthRemoteDataResource.refresh])
/// proactively when the stored token is expired, and once more on a 401
/// before giving up. Intended for future authenticated endpoints — the
/// auth endpoints themselves (login/register/refresh) must keep using a
/// plain [http.Client] to avoid recursing into this client.
class AuthenticatedHttpClient extends http.BaseClient {
  AuthenticatedHttpClient({
    required http.Client inner,
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataResource remoteDataResource,
  }) : _inner = inner,
       _localDataSource = localDataSource,
       _remoteDataResource = remoteDataResource;

  final http.Client _inner;
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataResource _remoteDataResource;

  Future<AuthTokenModel?>? _refreshing;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var tokens = await _localDataSource.getTokens();
    if (tokens != null && tokens.isExpired) {
      tokens = await _refreshTokens(tokens);
    }
    if (tokens != null) {
      request.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }

    final response = await _inner.send(request);
    if (response.statusCode != 401 || tokens == null) {
      return response;
    }

    final refreshed = await _refreshTokens(tokens);
    if (refreshed == null) {
      return response;
    }
    return _inner.send(_copyRequest(request, refreshed.accessToken));
  }

  Future<AuthTokenModel?> _refreshTokens(AuthTokenModel current) {
    return _refreshing ??= _doRefresh(
      current,
    ).whenComplete(() => _refreshing = null);
  }

  Future<AuthTokenModel?> _doRefresh(AuthTokenModel current) async {
    try {
      final refreshed = await _remoteDataResource.refresh(
        current.refreshToken,
      );
      await _localDataSource.saveTokens(refreshed);
      return refreshed;
    } catch (_) {
      await _localDataSource.clearTokens();
      return null;
    }
  }

  http.BaseRequest _copyRequest(http.BaseRequest request, String accessToken) {
    final copy = http.Request(request.method, request.url)
      ..headers.addAll(request.headers)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..followRedirects = request.followRedirects
      ..persistentConnection = request.persistentConnection;
    if (request is http.Request) {
      copy.bodyBytes = request.bodyBytes;
    }
    return copy;
  }
}
