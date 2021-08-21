// @dart = 2.9
import 'package:chat/services/encryption/encryption_service_contract.dart';
import 'package:chat/services/encryption/encryption_service_implement.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IEncryptionService encryptionService;

  setUp(() {
    final _encrypter = Encrypter(AES(Key.fromLength(32)));
    encryptionService = EncryptionService(_encrypter);
  });

  test('encrypted plain text', () {
    final text = 'This is a message';
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
    final encrypted = encryptionService.encrypt(text);

    expect(base64.hasMatch(encrypted), true);
  });

  test('decrypts the encrypted text', () {
    final text = 'this is a message';
    final encrypted = encryptionService.encrypt(text);
    final decrypted = encryptionService.decrypt(encrypted);

    expect(decrypted, text);
  });
}
