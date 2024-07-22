import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:chai_flutter_demo_app/checkout_elements/cart_details.dart';
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

import '../checkout_elements/address_element.dart';
import '../checkout_elements/name_and_logo_element.dart';
import '../checkout_elements/payment_methods_elements.dart';

class Checkout extends StatefulWidget {
  static String routeName = "/checkout_elements";
  GlobalCheckoutRequest checkoutRequest;

  Checkout({key, required this.checkoutRequest});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
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
      body: SafeArea(
        child: Container(
            color: Colors.grey[100],
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        NameLogo(
                          logo: "assets/images/apple-pay.png",
                          name: "Merchant Name",
                        ),
                        ShippingDetails(
                          address:
                              "A-301, Nirmal Complex, Station Road, Navsari, Gujarat, India-396445",
                        ),
                        const Divider(color: Colors.black, thickness: 1),
                        CartDetails(
                            productList:
                                widget.checkoutRequest.orderDetails ?? [],
                            currency: widget.checkoutRequest.currency ?? ""),
                        const Divider(thickness: 1),
                        PaymentMethods(
                          portone: portone,
                          checkoutRequest: widget.checkoutRequest,
                          jwtToken: requests.getJWTToken(),
                        )
                      ],
                    ),
                  ),
                ),
                BottomNavigation(
                  portone: portone,
                  checkoutRequest: widget.checkoutRequest,
                ),
              ],
            )),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation(
      {Key? key, required this.portone, required this.checkoutRequest})
      : super(key: key);
  PortOneImpl portone;
  GlobalCheckoutRequest checkoutRequest;
  CheckoutTheme checkoutTheme = CheckoutTheme(null, Colors.pink);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet<dynamic>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                builder: (context) => SavedCardsBottomSheet(
                    portone: portone,
                    totalAmount: 20000.00,
                    checkoutRequest: checkoutRequest,
                    savedCards: null),
              );
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset("assets/images/successful-card-payment.png"),
              Text(
                "Get Saved Cards Now",
                style: TextStyle(
                    color: checkoutTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: checkoutTheme.primaryColor,
                size: 20,
              )
            ]),
          ),
          const Divider(
            thickness: 1,
          ),
          const Row(
            children: [
              Text("Total"),
              Icon(Icons.keyboard_arrow_up),
              Spacer(),
              Text(
                "20,000.00THB",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
