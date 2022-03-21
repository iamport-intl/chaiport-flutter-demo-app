import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:chai_flutter_demo_app/utils/jwt_token_generation.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/dto/requests/web_checkout_request.dart';
import 'package:chaipay_flutter_package/dto/requests/with_tokenization_request.dart';
import 'package:chaipay_flutter_package/dto/requests/without_tokenization_request.dart';

class Requests {
  SignatureHash hash = SignatureHash();
  JwtTokenGeneration jwt = JwtTokenGeneration();
  RandomStringsGeneration randomString = RandomStringsGeneration();

  String clientKey = CLIENT_KEY;
  String secretKey = SECRET_KEY;
  String mobileNo = "+919913379694";
  final environment = "live";

  String getJWTToken() {
    return "Bearer " + jwt.getJWTToken();
  }

  WebCheckoutRequest getRequestBody() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash("50010", "VND",
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

  WithTokenizationRequest getTokenizationRequest() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash("50010", "VND",
        "https://www.bing.com", orderId, clientKey, "https://www.google.com");
    WithTokenizationRequest tokenizationRequest = WithTokenizationRequest(
        amount: 50010,
        billingDetails:
            BillingDetailsTokenization(billingPhone: "+919913379694"),
        tokenParams: TokenParams(
            expiryMonth: "05",
            expiryYear: "2021",
            saveCard: false,
            partialCardNumber: "222300******0023",
            token: "f842b1675abb4311a70bb0b9720dd371",
            type: "mastercard"),
        currency: "VND",
        failureUrl: "https://www.bing.com",
        key: clientKey,
        merchantOrderId: orderId,
        pmtChannel: "BAOKIM",
        pmtMethod: "BAOKIM_ATM_CARD",
        redirectUrl: "chaipay://checkout",
        signatureHash: signatureHash,
        successUrl: "https://www.google.com",
        environment: "live");
    return tokenizationRequest;
  }

  WithoutTokenizationRequest getWithoutTokenizationRequest() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash("50010", "VND",
        "https://www.bing.com", orderId, clientKey, "https://www.google.com");
    WithoutTokenizationRequest tokenizationRequest = WithoutTokenizationRequest(
        amount: 50010,
        billingDetails: BillingDetails(
            billingAddress: BillingAddress(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            billingEmail: "markweins@gmail.com",
            billingName: "Test mark",
            billingPhone: "9998878788"),
        currency: "VND",
        env: "dev",
        failureUrl: "https://www.bing.com",
        key: clientKey,
        merchantOrderId: orderId,
        orderDetails: [
          OrderDetails(
              id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
        ],
        pmtChannel: "MOMOPAY",
        pmtMethod: "MOMOPAY_WALLET",
        redirectUrl: "chaipay://checkout",
        shippingDetails: ShippingDetails(
            shippingAddress: BillingAddress(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: "9998878788"),
        signatureHash: signatureHash,
        successUrl: "https://www.google.com",
        environment: "live");
    return tokenizationRequest;
  }
}
