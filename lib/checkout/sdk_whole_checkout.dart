import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:chai_flutter_demo_app/checkout_elements/saved_cards_bottomsheet.dart';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:portone_flutter_package/checkout_theme.dart';
import 'package:portone_flutter_package/constants/constants.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:portone_flutter_package/dto/responses/with_tokenization_response.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/screens/checkout/checkout_screen.dart';
import 'package:portone_flutter_package/screens/checkout/components/body.dart';
import 'package:portone_flutter_package/screens/checkout/components/cart_details.dart';
import 'package:portone_flutter_package/screens/checkout/components/payment_methods.dart';

class SdkWholeCheckout extends StatefulWidget {
  static String routeName = "/sdk_whole_checkout";
  GlobalCheckoutRequest checkoutRequest;

  SdkWholeCheckout({key, required this.checkoutRequest});

  @override
  State<SdkWholeCheckout> createState() => _SdkWholeCheckoutState();
}

class _SdkWholeCheckoutState extends State<SdkWholeCheckout> {
  late int selectedRadioTile;
  late PortOneImpl portone;

  late List<Content>? savedCards;
  late Content selectedCard;

  late List<PaymentMethod>? walletsList;
  late PaymentMethodResponse paymentMethodsResponse;
  late PaymentMethod selectedWallet;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Requests requests = Requests();
  CheckoutTheme checkoutTheme = CheckoutTheme(null, Colors.pink);

  @override
  void initState() {
    super.initState();

    portone = PortOneImpl(context, "sandbox", checkoutTheme, false, DEV);

    portone.setSavedCardsListener(
        callback: (CreditCardDetailsResponse response) {
      print('PortOne_Response-> $response');
      savedCards = response.content;
    });

    portone.setPaymentMethodsListener(
        callback: (PaymentMethodResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response_PaymentMethod-> $response--> $json');
      paymentMethodsResponse = response;
    });

    portone.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      print('CHAI_PaymentStatus-> $paymentStatus');
    });

    portone.setCheckoutWithTokenizationListener(
        callback: (WithTokenizationResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response_CheckoutWithTokenization-> $response--> $json');
    });
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      portone.processPaymentStatus(uri.toString(), "sandbox");
      print('onAppLink: $uri');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:Colors.grey[100] ,),
      body: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              Expanded(
                child: CheckoutScreen(
                  checkoutRequest: requests.getGlobalCheckoutRequest(),
                  portone: portone,
                  jwtToken: requests.getJWTToken(),
                ),
              ),
            ],
          )),
    );
  }
}
