import 'dart:async';
import 'package:chai_flutter_demo_app/home.dart';
import 'package:flutter/material.dart';
import 'package:chaipay_flutter_package/chaiport_classes/chaiport_impl.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

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
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
    chai.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      print('CHAI_PaymentStatus-> $paymentStatus');
      navigateHome(paymentStatus);
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

  void navigateHome(Map paymentStatus) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Home()));
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      print("initialLink--> $initialLink");
      _sub = linkStream.listen((String? link) {
        print("deeplink--> $link");
        if (link != null) {
          chai.processPaymentStatus(link, environment);
        }
        // Parse the link and warn the user, if it is not correct
      }, onError: (err) {
        print(err);
      });
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}
