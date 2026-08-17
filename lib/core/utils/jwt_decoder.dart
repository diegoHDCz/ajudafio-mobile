import 'dart:convert';

class JwtDecoder {
  JwtDecoder._();

  static Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT format.');
    }

    final payload = jsonDecode(_decodeBase64(parts[1]));
    if (payload is! Map<String, dynamic>) {
      throw const FormatException('Invalid JWT payload.');
    }
    return payload;
  }

  static String _decodeBase64(String input) {
    var output = input.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw const FormatException('Invalid base64 string.');
    }
    return utf8.decode(base64.decode(output));
  }
}
