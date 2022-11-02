import 'package:chai_flutter_demo_app/constants/constants.dart';
import 'package:chai_flutter_demo_app/utils/jwt_token_generation.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/constants/constants.dart';
import 'package:chaipay_flutter_package/dto/requests/bank_list_request.dart';
import 'package:chaipay_flutter_package/dto/requests/billing_details.dart';
import 'package:chaipay_flutter_package/dto/requests/chanex_token_request.dart';
import 'package:chaipay_flutter_package/dto/requests/checkout_with_direct_bank_transfer_request.dart';
import 'package:chaipay_flutter_package/dto/requests/checkout_with_installation_request.dart';
import 'package:chaipay_flutter_package/dto/requests/order_details.dart';
import 'package:chaipay_flutter_package/dto/requests/shipping_details.dart';
import 'package:chaipay_flutter_package/dto/requests/web_checkout_request.dart';
import 'package:chaipay_flutter_package/dto/requests/with_tokenization_request.dart';
import 'package:chaipay_flutter_package/dto/requests/without_tokenization_request.dart';

class Requests {
  final devEnvironment = PRODUCTION;
  final clientKey = CLIENT_KEY_Prod1;
  final secretKey = SECRET_KEY_Prod1;
  final mobileNo = "+919913379694";
  final environment = SANDBOX;
  final currency = THB;
  final paymentChannel = "CHAIPORT";
  final paymentMethod = "CHAIPORT_DIRECT_BANK_TRANSFER";

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
        orderDetails: <OrderDetails>[
          OrderDetails(
              id: "knb", name: "kim nguyen bao", price: 19010.2, quantity: 1)
        ],
        mobileRedirectUrl: "chaipay://checkout",
        shippingDetails: ShippingDetails(
            shippingAddress: ShippingAddress(
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
        billingDetails: BillingDetails(
            billingAddress: BillingAddress(
                city: "TH",
                countryCode: "TH",
                locale: "en",
                line1: "address",
                line2: "address_2",
                postalCode: "400202",
                state: "Mah"),
            billingEmail: "markweins@gmail.com",
            billingName: "Test mark",
            billingPhone: mobileNo),
        shippingDetails: ShippingDetails(
            shippingAddress: ShippingAddress(
                city: "TH",
                countryCode: "TH",
                locale: "en",
                line1: "address",
                line2: "address_2",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: mobileNo),
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
          OrderDetails(
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
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "20210",
        currency: currency,
        failureUrl: "https://www.bing.com",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://www.google.com");
    WithoutTokenizationRequest tokenizationRequest = WithoutTokenizationRequest(
        amount: 20210,
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
            billingPhone: "+848959893980"),
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
            shippingAddress: ShippingAddress(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: mobileNo),
        signatureHash: signatureHash,
        successUrl: "https://www.google.com",
        environment: environment,
        source: "mobile");
    return tokenizationRequest;
  }

  ChanexTokenRequest getChanexTokenRequest() {
    ChanexTokenRequest chanexTokenRequest =
        ChanexTokenRequest(card: vtcPayCreditCard());
    return chanexTokenRequest;
  }

  CheckoutWithDirectBankTransferRequest
      getCheckoutWithDirectBankTransferRequest() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "50010",
        currency: currency,
        failureUrl: "https://www.bing.com",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://www.google.com");
    CheckoutWithDirectBankTransferRequest request =
        CheckoutWithDirectBankTransferRequest(
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
                billingPhone: mobileNo),
            currency: currency,
            env: "dev",
            failureUrl: "https://www.bing.com",
            key: clientKey,
            source: "mobile",
            merchantOrderId: orderId,
            orderDetails: [
              OrderDetails(
                  id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
            ],
            pmtChannel: paymentChannel,
            pmtMethod: paymentMethod,
            shippingDetails: ShippingDetails(
                shippingAddress: ShippingAddress(
                    city: "VND",
                    countryCode: "VN",
                    line1: "address",
                    line2: "address_2",
                    locale: "en",
                    postalCode: "400202",
                    state: "Mah"),
                shippingEmail: "markweins@gmail.com",
                shippingName: "Test mark",
                shippingPhone: mobileNo),
            signatureHash: signatureHash,
            successUrl: "https://www.google.com",
            environment: environment);
    return request;
  }

  CheckoutWithInstallationRequest getCheckoutWithInstallationRequest() {
    String orderId = randomString.getRandomString(6);
    String signatureHash = hash.getSignatureHash(
        amount: "50010",
        currency: currency,
        failureUrl: "https://www.bing.com",
        orderId: orderId,
        clientKey: clientKey,
        successUrl: "https://www.google.com");
    CheckoutWithInstallationRequest request = CheckoutWithInstallationRequest(
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
            billingPhone: mobileNo),
        currency: currency,
        env: "dev",
        failureUrl: "https://www.bing.com",
        key: clientKey,
        source: "mobile",
        merchantOrderId: orderId,
        orderDetails: [
          OrderDetails(
              id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
        ],
        pmtChannel: paymentChannel,
        pmtMethod: paymentMethod,
        redirectUrl: "chaipay://checkout",
        shippingDetails: ShippingDetails(
            shippingAddress: ShippingAddress(
                city: "VND",
                countryCode: "VN",
                line1: "address",
                line2: "address_2",
                locale: "en",
                postalCode: "400202",
                state: "Mah"),
            shippingEmail: "markweins@gmail.com",
            shippingName: "Test mark",
            shippingPhone: mobileNo),
        signatureHash: signatureHash,
        successUrl: "https://www.google.com",
        bankDetails: BankDetails(
            bankCode: "installment_bay",
            bankName: "Krungsri",
            isMerchantSponsored: false,
            installmentPeriod: InstallmentPeriod(month: 4, interest: 0.8)),
        environment: environment);
    return request;
  }

  BankListRequest getBankListRequest() {
    const paymentMethod = "OMISE_INSTALLMENT";
    BankListRequest request = BankListRequest();
    request.amount = 20023;
    request.environment = environment;
    request.iamportKey = clientKey;
    request.isMerchantSponsored = false;
    request.methodKey = paymentMethod;
    request.overrideDefault = false;
    return request;
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

  Card gbppDebiCard() {
    Card card = Card(
        cardNumber: "4535017710535741",
        cardType: "Visa",
        cardholderName: "NGUYEN VAN A",
        serviceCode: "184",
        expirationYear: "2028",
        expirationMonth: "05",
        saveCard: true);
    return card;
  }
}
