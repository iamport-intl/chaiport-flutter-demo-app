import 'dart:convert' show Utf8Encoder, base64, base64Encode, utf8;
import 'package:crypto/crypto.dart';

class SignatureHash {
  //B9iBft1Enqm8g5iP+qQBLKD8U3QyA1uZ/vP/cb4JafQ=
  String message = "";
  String SECRET_KEY_Dev3 =
      "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5";

  String getSignatureHash(String amount, String currency, String failureUrl,
      String orderId, String clientKey, String successUrl) {
    Map<String, String> params = {
      "amount": amount,
      "client_key": clientKey,
      "currency": currency,
      "failure_url": failureUrl,
      "merchant_order_id": orderId,
      "success_url": successUrl
    };
    params.forEach((key, value) {
      var encodedValue = Uri.encodeComponent(value);
      if (message.isNotEmpty) {
        message = message + "&$key=$encodedValue";
      } else {
        message = message + "$key=$encodedValue";
      }
    });
    final keyBytes = const Utf8Encoder().convert(SECRET_KEY_Dev3);
    final dataBytes = const Utf8Encoder().convert(message);
    final hmacBytes = Hmac(sha256, keyBytes).convert(dataBytes).bytes;
    final hmacBase64 = base64Encode(hmacBytes);
    return hmacBase64;
  }

}
