// import 'package:encrypt/encrypt.dart';

// class EncryptionHelper {
//   static final _key = Key.fromUtf8('1234567890123456'); 
// static final _iv = IV.fromUtf8('abcdefghijklmnop');

//   static String encryptPassword(String plainText) {
//     final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
//     final encrypted = encrypter.encrypt(plainText, iv: _iv);
//     return encrypted.base64;
//   }
//   static String encryptCorreo(String plainText) {
//     final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
//     final encrypted = encrypter.encrypt(plainText, iv: _iv);
//     return encrypted.base64;
//   }
// }