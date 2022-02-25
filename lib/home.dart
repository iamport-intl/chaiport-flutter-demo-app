import 'package:chai_flutter_demo_app/utils/jwt_token_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/chaiport_classes/chaiport_impl.dart';
import 'package:chaipay_flutter_package/dto/requestes/web_checkout_request.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ChaiPortImpl chai;
  SignatureHash hash = SignatureHash();
  JwtTokenGeneration jwt = JwtTokenGeneration();
  late WebCheckoutRequest orderDetails;

  late String signatureHash;
  late String jwtToken;
  late String orderId;
  late String clientKey;

  @override
  void initState() {
    super.initState();
    jwtToken =
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJDSEFJUEFZIiwic3ViIjoiYWlIS2FmS0lic2RVSkRPYiIsImlhdCI6MTY0NTYyMTgxNiwiZXhwIjoxNjQ1NjIxOTE2fQ.xp18wg3zbblIfc3w0v-6Ar3c-JNnz58TMhELMjmJWSU";
    signatureHash = "cDoWMhvGpYQTM8xzw5Z7h5txsZID4slnB1UHdeM7WCc=";
    clientKey = "aiHKafKIbsdUJDOb";
    orderId = "hdTqTsAZAp";

    chai = ChaiPortImpl(context, "sandbox");
    orderDetails = WebCheckoutRequest(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Shop"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 60.0),
          child: Column(
            children: [
              const Text(
                "Welcome to the Shop",
                style: TextStyle(fontSize: 35),
              ),
              ElevatedButton(
                onPressed: () {
                  // chai.getOTP("+919913379694");
                  // chai.checkoutUsingWeb(jwtToken, clientKey, orderDetails);
                  // hash.getSignatureHash("50010", "VND", "https://www.bing.com",
                  //     orderId, clientKey, "https://www.google.com");
                  jwt.getJWTToken();
                  // chai.getPaymentMethods(clientKey);
                  // chai.getSavedCards(
                  //     "", clientKey, "+919913379694", "");
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                  child: Text('Checkout',
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
