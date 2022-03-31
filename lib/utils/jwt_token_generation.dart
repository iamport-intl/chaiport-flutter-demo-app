import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtTokenGeneration {
  String getJWTToken() {

    final claimSet = JwtClaim(
        issuedAt: DateTime.now(),
        expiry: DateTime.now().add(const Duration(seconds: 100)),
        issuer: "CHAIPAY",
        subject: CLIENT_KEY,
        otherClaims: <String, dynamic>{
          "typ": "JWT",
          "alg": "HS256",
        });

    String token = issueJwtHS256(claimSet, SECRET_KEY);
    print(token);

    return token;
  }
}
