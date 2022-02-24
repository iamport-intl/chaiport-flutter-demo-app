import 'dart:async';
import 'package:chai_flutter_demo_app/home.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
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
  final environment = "sandbox";
  late ChaiPortImpl chai = ChaiPortImpl(context, environment);
  late StreamSubscription _intentData;
  String? paymentStatus;

  @override
  void initState() {
    super.initState();

    chai.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      print('CHAI_PaymentStatus-> $paymentStatus');
    });
    _intentData = ReceiveSharingIntent.getTextStream().listen((String url) {
      setState(() {
        chai.processPaymentStatus(url, environment);
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
}
