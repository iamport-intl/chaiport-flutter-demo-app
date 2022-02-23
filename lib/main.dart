import 'dart:async';
import 'dart:collection';

import 'package:chai_flutter_demo_app/home.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaipay_flutter_package/chaiport_classes/chaiport_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ChaiPortImpl chai = ChaiPortImpl(context, "dev");
  late StreamSubscription _intentData;
  String? paymentStatus;

  @override
  void initState() {
    super.initState();

    saveEnvironment();
    getEnvironment();
    _intentData = ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        paymentStatus = value;
        extractParams(value);
      });
    });
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        paymentStatus = value;
        extractParams(value!);
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
    return const MaterialApp(
      home: Home(),
    );
  }

  saveEnvironment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('environment', "abc");
  }

  getEnvironment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('environment');
    print(stringValue);
    return stringValue;
  }

  void extractParams(String url) {
    var uri = Uri.parse(url);
    var paramNames = uri.queryParameters;
    var channels = uri.path.split("/");
    var channel = channels[1];
    if (paramNames.containsKey("tokenization_possible") &&
        paramNames["tokenization_possible"] == true) {
      // go back to merchant
    } else {
      HashMap<String, String> paramsMap = HashMap();
      paramsMap["chaiMobileSDK"] = "true";
      paramsMap.addAll(paramNames);
      chai.updatePaymentStatus(channel, paramsMap);
    }
    chai.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      print('CHAI_PaymentStatus-> $paymentStatus');
      // navigateToNextScreen(paymentStatus);
    });
  }

  void navigateToNextScreen(Map<String, dynamic> paymentStatus) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Result(paymentStatus: paymentStatus)));
  }
}
