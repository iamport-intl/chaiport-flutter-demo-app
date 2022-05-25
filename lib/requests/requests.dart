import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:chai_flutter_demo_app/utils/jwt_token_generation.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/constants/constants.dart';
import 'package:chaipay_flutter_package/dto/requests/chanex_token_request.dart';
import 'package:chaipay_flutter_package/dto/requests/web_checkout_request.dart';
import 'package:chaipay_flutter_package/dto/requests/with_tokenization_request.dart';
import 'package:chaipay_flutter_package/dto/requests/without_tokenization_request.dart';

class Requests {
  final devEnvironment = PRODUCTION;
  final clientKey = CLIENT_KEY_Prod1;
  final secretKey = SECRET_KEY_Prod1;
  final mobileNo = "+919913379694";
  final environment = SANDBOX;
  final currency = SGD;

  SignatureHash hash = SignatureHash();
  JwtTokenGeneration jwt = JwtTokenGeneration();
  RandomStringsGeneration randomString = RandomStringsGeneration();

  String getJWTToken() {
    return "Bearer " + jwt.getJWTToken();
  }

  WebCheckoutRequest getRequestBody() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "19010.2",
        currency: currency,
        failureUrl: "https://dev-checkout.chaipay.io/failure.html",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://dev-checkout.chaipay.io/success.html");
    WebCheckoutRequest webCheckoutRequest = WebCheckoutRequest(
        amount: 19010.2,
        billingDetails: BillingDetailsWebCheckout(
            billingAddress: BillingAddressWebCheckout(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            billingEmail: "markweins@gmail.com",
            billingName: "Test mark",
            billingPhone: "+848959893980"),
        chaipayKey: clientKey,
        countryCode: "VN",
        currency: currency,
        defaultGuestCheckout: false,
        description: "By Aagam",
        env: devEnvironment,
        expiryHours: 1,
        failureUrl: "https://dev-checkout.chaipay.io/failure.html",
        isCheckoutEmbed: false,
        merchantDetails: MerchantDetails(
            name: "Gumnam",
            backUrl: "https://demo.chaipay.io/checkout.html",
            logo:
                "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg",
            promoCode: null,
            promoDiscount: 10000.00,
            shippingCharges: 10000.00),
        merchantOrderId: orderId,
        orderDetails: <OrderDetailsWebCheckout>[
          OrderDetailsWebCheckout(
              id: "knb", name: "kim nguyen bao", price: 19010.2, quantity: 1)
        ],
        mobileRedirectUrl: "chaipay://checkout",
        shippingDetails: ShippingDetailsWebCheckout(
            shippingAddress: BillingAddressWebCheckout(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: "+848959893980"),
        showBackButton: true,
        showShippingDetails: true,
        signatureHash: signatureHash,
        source: "api",
        successUrl: "https://dev-checkout.chaipay.io/success.html",
        environment: environment);
    return webCheckoutRequest;
  }

  WithTokenizationRequest getTokenizationRequest() {
    const paymentChannel = "VTCPAY";
    const paymentMethod = "VTCPAY_CREDIT_CARD";
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "50010",
        currency: currency,
        failureUrl: "https://www.bing.com",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://www.google.com");
    WithTokenizationRequest tokenizationRequest = WithTokenizationRequest(
        amount: 50010,
        billingDetails: BillingDetailsTokenization(
            billingAddress: BillingAddressTokenization(
                city: "TH",
                countryCode: "TH",
                locale: "en",
                line1: "address",
                line2: "address_2",
                postalCode: "400202",
                state: "Mah"),
            billingEmail: "markweins@gmail.com",
            billingName: "Test mark",
            billingPhone: "9998878788"),
        shippingDetails: ShippingDetailsTokenization(
            shippingAddress: BillingAddressTokenization(
                city: "TH",
                countryCode: "TH",
                locale: "en",
                line1: "address",
                line2: "address_2",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: "9998878788"),
        tokenParams: TokenParams(
            expiryMonth: "04",
            expiryYear: "2025",
            saveCard: true,
            partialCardNumber: "4111 1******1111",
            token: "09d14c38ac8e4b93ae0005655f4901f1",
            type: "visa"),
        currency: currency,
        failureUrl: "https://www.bing.com",
        key: clientKey,
        merchantOrderId: orderId,
        orderDetails: [
          OrderDetailsTokenization(
              id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
        ],
        pmtChannel: paymentChannel,
        pmtMethod: paymentMethod,
        redirectUrl: "chaipay://checkout",
        signatureHash: signatureHash,
        successUrl: "https://www.google.com",
        environment: environment);
    return tokenizationRequest;
  }

  WithoutTokenizationRequest getWithoutTokenizationRequest() {
    const paymentChannel = "PAYPAL";
    const paymentMethod = "PAYPAL_ALL";
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "50010",
        currency: currency,
        failureUrl: "https://www.bing.com",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://www.google.com");
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
        currency: currency,
        env: "dev",
        failureUrl: "https://www.bing.com",
        key: clientKey,
        merchantOrderId: orderId,
        orderDetails: [
          OrderDetails(
              id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
        ],
        pmtChannel: paymentChannel,
        pmtMethod: paymentMethod,
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
        source: "mobile",
        environment: environment);
    return tokenizationRequest;
  }

  ChanexTokenRequest getChanexTokenRequest() {
    ChanexTokenRequest chanexTokenRequest =
        ChanexTokenRequest(card: vtcPayCreditCard());
    return chanexTokenRequest;
  }

  Card adayenCard() {
    Card card = Card(
        cardholderName: "NGUYEN VAN A",
        cardType: "Visa",
        cardNumber: "4111111145551142",
        expirationMonth: "03",
        expirationYear: "2030",
        serviceCode: "737",
        saveCard: true);
    return card;
  }

  Card omiseCreditCard() {
    Card card = Card(
        cardNumber: "4000000000000002",
        cardType: "Visa",
        cardholderName: "NGUYEN VAN A",
        serviceCode: "737",
        expirationYear: "2022",
        expirationMonth: "11",
        saveCard: true);
    return card;
  }

  Card vtcPayCreditCard() {
    Card card = Card(
        cardNumber: "4111111111111111",
        cardType: "Visa",
        cardholderName: "NGUYEN VAN A",
        serviceCode: "123",
        expirationYear: "2030",
        expirationMonth: "01",
        saveCard: true);
    return card;
  }
}
