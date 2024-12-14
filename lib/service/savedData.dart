import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: SecureStorageKeys.access_token.name, value: accessToken);
    await _storage.write(key: SecureStorageKeys.refresh_token.name, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: SecureStorageKeys.access_token.name);
  }

  Future<void> updateAccessToken(String newAccessToken) async {
    await _storage.delete(key: SecureStorageKeys.access_token.name);
    await _storage.write(key: SecureStorageKeys.access_token.name, value: newAccessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: SecureStorageKeys.refresh_token.name);
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: SecureStorageKeys.access_token.name);
    await _storage.delete(key: SecureStorageKeys.refresh_token.name);
  }

  Future<File?> pickedAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null) {
      final File file = File(result.files.single.path!);
      return file;
    }
    return null;
  }

}

enum SecureStorageKeys {access_token, refresh_token}
