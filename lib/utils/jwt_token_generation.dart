import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtTokenGeneration {
  String getJWTToken() {
    Requests requests = Requests();

    final claimSet = JwtClaim(
        issuedAt: DateTime.now(),
        expiry: DateTime.now().add(const Duration(seconds: 100)),
        issuer: "CHAIPAY",
        subject: requests.clientKey,
        otherClaims: <String, dynamic>{
          "typ": "JWT",
          "alg": "HS256",
        });

    String token = issueJwtHS256(claimSet, requests.secretKey);
    print("JWTToken--> $token");

    return token;
  }
}
