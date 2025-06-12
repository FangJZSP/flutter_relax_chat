import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

import '../common/info.dart';

class CryptoHelper {
  static final String _defaultKey = Info.ap;

  static final _key = Key.fromUtf8(_defaultKey);
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.ecb));
  static final _iv = IV.fromLength(16);

  /// 加密数据
  static String encryptData(String data) {
    try {
      final encrypted = _encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      throw Exception('加密失败: $e');
    }
  }

  /// 解密数据
  static String decryptData(String encryptedData) {
    try {
      final encrypted = Encrypted.fromBase64(encryptedData);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      throw Exception('解密失败: $e');
    }
  }

  /// 加密JSON数据
  static String encryptJson(Map<String, dynamic> data) {
    final jsonString = json.encode(data);
    return encryptData(jsonString);
  }

  /// 解密JSON数据
  static Map<String, dynamic> decryptJson(String encryptedData) {
    final decryptedString = decryptData(encryptedData);
    return json.decode(decryptedString) as Map<String, dynamic>;
  }

  /// 生成请求签名
  static String generateSignature(String data, String timestamp) {
    final key = utf8.encode(_defaultKey);
    final message = utf8.encode('$data$timestamp');
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(message);
    return digest.toString();
  }

  /// 验证响应签名
  static bool verifySignature(String data, String timestamp, String signature) {
    final expectedSignature = generateSignature(data, timestamp);
    return expectedSignature == signature;
  }
}
