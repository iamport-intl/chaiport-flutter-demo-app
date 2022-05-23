import 'dart:async';
import 'dart:convert';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/chaiport_services/chaiport_impl.dart';
import 'package:chaipay_flutter_package/dto/responses/chanex_token_response.dart';
import 'package:chaipay_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:chaipay_flutter_package/dto/responses/get_otp_response.dart';
import 'package:chaipay_flutter_package/dto/responses/payment_method_response.dart';
import 'package:chaipay_flutter_package/dto/responses/with_tokenization_response.dart';
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
      final json = jsonEncode(paymentStatus);
      print('CHAIPort_PaymentStatus-> $json');
      navigateToResult(paymentStatus);
    });

    chai.setPaymentLinkListener(callback: (String paymentLink) {
      print('CHAIPort_PaymentLink-> $paymentLink');
    });

    _intentData =
        ReceiveSharingIntent.getTextStream().listen((String deeplink) {
      setState(() {
        chai.processPaymentStatus(deeplink, requests.environment);
        print(
            'CHAIPort_DeepLink_Received-> ${requests.environment}  $deeplink');
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
                  chai.checkoutUsingWeb(requests.getJWTToken(),
                      requests.clientKey, requests.getRequestBody(), chai);
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
