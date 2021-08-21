import 'package:chat/services/encryption/encryption_service_contract.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryptionService {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: this._iv);
  }

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: this._iv).base64;
  }
}
