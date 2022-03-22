import 'dart:async';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/chaiport_classes/chaiport_impl.dart';
import 'package:chaipay_flutter_package/dto/responses/chanex_token_response.dart';
import 'package:chaipay_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:chaipay_flutter_package/dto/responses/get_otp_response.dart';
import 'package:chaipay_flutter_package/dto/responses/payment_method_response.dart';
import 'package:chaipay_flutter_package/dto/responses/without_tokenization_response.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ChaiPortImpl chai;
  Requests requests = Requests();
  late StreamSubscription _intentData;
  SignatureHash hash = SignatureHash();

  @override
  void initState() {
    super.initState();

    chai = ChaiPortImpl(context, requests.environment);
    chai.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      print('CHAI_PaymentStatus-> $paymentStatus');
      navigateToResult(paymentStatus);
    });
    chai.setOtpListener(callback: (GetOtpResponse response) {
      print('CHAI_Response-> $response');
    });
    chai.setPaymentMethodsListener(callback: (PaymentMethodResponse response) {
      print('CHAI_Response-> $response');
    });
    chai.setSavedCardsListener(callback: (CreditCardDetailsResponse response) {
      print('CHAI_Response-> $response');
    });
    chai.setCheckoutWithTokenizationListener(callback: (dynamic response) {
      print('CHAI_Response-> $response');
    });
    chai.setCheckoutWithoutTokenizationListener(callback: (WithoutTokenizationResponse response) {
      print('CHAI_Response-> $response');
    });
    chai.setTokenCallBackListener(callback: (ChanexTokenResponse response) {
      print('CHAI_Response-> $response');
    });
    _intentData = ReceiveSharingIntent.getTextStream().listen((String url) {
      setState(() {
        chai.processPaymentStatus(url, requests.environment);
      });
    });
  }

  @override
  void dispose() {
    _intentData.cancel();
    super.dispose();
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
                  // chai.getOTP(requests.mobileNo);
                  // chai.checkoutUsingWeb(requests.getJWTToken(),
                  //     requests.clientKey, requests.getRequestBody());
                  // chai.getPaymentMethods(requests.clientKey);
                  // chai.getSavedCards(
                  //     "", requests.clientKey, requests.mobileNo, "670517");
                  chai.checkoutWithTokenization(
                      requests.getTokenizationRequest());
                  // chai.checkoutWithoutTokenization(
                  //     requests.getWithoutTokenizationRequest());
                  // chai.getToken(requests.getChanexTokenRequest());
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

  void navigateToResult(Map paymentStatus) {
    try {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Result(paymentStatus: paymentStatus)));
    } catch (exception) {
      print(exception.toString());
    }
  }
}
