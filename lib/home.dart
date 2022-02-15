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
  late WebCheckoutRequest orderDetails;

  late String signatureHash;
  late String jwtToken;
  late String orderId;
  late String clientKey;

  @override
  void initState() {
    super.initState();
    jwtToken =
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJDSEFJUEFZIiwic3ViIjoiYWlIS2FmS0lic2RVSkRPYiIsImlhdCI6MTY0NDgzOTg0NCwiZXhwIjoxNjQ0ODM5OTQ0fQ.yr_Xyn2FlGP4ErdVgW_aoULxw41f4Xa83pImr62AY-o";
    signatureHash = "adrGAlY3FNnztTiP50OsddQIpudfWExzCyRmZlOVhlg=";
    clientKey = "aiHKafKIbsdUJDOb";
    orderId = "EmHjd54fD9";

    chai = ChaiPortImpl(context, "dev");
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
        Merchant_details("Gumnam", "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg",
            "Gumnam420", 10000, 10000.00),
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
                  chai.getOTP("+919913379694");
                  // chai.checkoutUsingWeb(jwtToken, clientKey, orderDetails);
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
