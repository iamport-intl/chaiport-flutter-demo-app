import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:chai_flutter_demo_app/utils/jwt_token_generation.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/dto/requestes/web_checkout_request.dart';

class Requests {
  SignatureHash hash = SignatureHash();
  JwtTokenGeneration jwt = JwtTokenGeneration();
  RandomStringsGeneration randomString = RandomStringsGeneration();

  late String signatureHash;
  late String jwtToken;
  late String orderId;

  String clientKey = CLIENT_KEY;
  String mobileNo = "+919913379694";
  final environment = "live";

  String getJWTToken() {
    return jwtToken = "Bearer " + jwt.getJWTToken();
  }

  WebCheckoutRequest getRequestBody() {
    orderId = randomString.getRandomString(6);
    signatureHash = hash.getSignatureHash("50010", "VND",
        "https://www.bing.com", orderId, clientKey, "https://www.google.com");
    WebCheckoutRequest webCheckoutRequest = WebCheckoutRequest(
        50010,
        Billing_details(
            billingAddress: Billing_address(
                "VND", "VN", "en", "address", "address_2", "400202", "Mah"),
            billingEmail: "markweins@gmail.com",
            billingName: "Test mark",
            billingPhone: "+848959893980"),
        clientKey,
        "VN",
        "VND",
        false,
        "By Aagam",
        "dev",
        1,
        "https://www.bing.com",
        false,
        Merchant_details(
            name: "Gumnam",
            backUrl: null,
            logo:
                "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg",
            promoCode: null,
            promoDiscount: 10000,
            shippingCharges: 10000.00),
        orderId,
        <Order_details>[Order_details("knb", "kim nguyen bao", 50010, 1)],
        "chaipay://checkout",
        Shipping_details(
            shippingAddress: Shipping_address(
                "VND", "VN", "en", "address", "address_2", "400202", "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: "+848959893980"),
        true,
        true,
        signatureHash,
        "api",
        "https://www.google.com",
        "live");
    return webCheckoutRequest;
  }
}
