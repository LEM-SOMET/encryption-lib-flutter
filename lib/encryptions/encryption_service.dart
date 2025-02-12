import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();

  EncryptionService._internal();

  factory EncryptionService() {
    return _instance;
  }

  encrypt.Key? _key;

  void init(String keyString) {
    _key = encrypt.Key.fromUtf8(keyString);
  }

  String encryptData(String plainText) {
    if (_key == null) {
      throw Exception('Encryption key is not initialized.');
    }
    final iv = encrypt.IV.fromLength(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final ivBase64 = iv.base64;
    final encryptedBase64 = encrypted.base64;
    return '$ivBase64:$encryptedBase64';
  }

  String decryptData(String encryptedData) {
    if (_key == null) {
      throw Exception('Encryption key is not initialized.');
    }
    final parts = encryptedData.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
