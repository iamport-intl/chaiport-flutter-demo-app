import 'dart:async';
import 'dart:convert';
import 'package:chai_flutter_demo_app/checkout/app_elements_checkout.dart';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portone_flutter_package/checkout_theme.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/dto/responses/add_card_for_customer_response.dart';
import 'package:portone_flutter_package/dto/responses/add_customer_response.dart';
import 'package:portone_flutter_package/dto/responses/bank_list_response.dart';
import 'package:portone_flutter_package/dto/responses/chanex_token_response.dart';
import 'package:portone_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:portone_flutter_package/dto/responses/direct_bank_transfer_details_response.dart';
import 'package:portone_flutter_package/dto/responses/generic_response.dart';
import 'package:portone_flutter_package/dto/responses/get_customer_data_response.dart';
import 'package:portone_flutter_package/dto/responses/get_otp_response.dart';
import 'package:portone_flutter_package/dto/responses/list_cards_for_customer_response.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:portone_flutter_package/dto/responses/routes_list_response.dart';
import 'package:portone_flutter_package/dto/responses/with_tokenization_response.dart';
import 'package:portone_flutter_package/dto/responses/without_tokenization_response.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'checkout/sdk_elements_checkout.dart';
import 'checkout/sdk_whole_checkout.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PortOneImpl portone;
  Requests requests = Requests();
  late StreamSubscription _intentData;
  SignatureHash hash = SignatureHash();
  RandomStringsGeneration randomString = RandomStringsGeneration();
  CheckoutTheme checkoutTheme = CheckoutTheme(null, Colors.pink);

  @override
  void initState() {
    super.initState();

    portone = PortOneImpl(context, requests.environment, checkoutTheme, false,
        requests.devEnvironment);

    portone.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      final json = jsonEncode(paymentStatus);
      print('CHAI_PaymentStatus-> $json');
      navigateToResult(paymentStatus);
    });
    portone.setOtpListener(callback: (GetOtpResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setPaymentMethodsListener(
        callback: (PaymentMethodResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setSavedCardsListener(
        callback: (CreditCardDetailsResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setCheckoutWithTokenizationListener(
        callback: (WithTokenizationResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setCheckoutWithoutTokenizationListener(
        callback: (WithoutTokenizationResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setTokenCallBackListener(callback: (ChanexTokenResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    portone.setPaymentLinkListener(callback: (String paymentLink) {
      print('CHAI_PaymentLink-> $paymentLink');
    });
    portone.setBankListListener(callback: (BankListResponse response) {
      final json = jsonEncode(response);
      print('CHAI_BankList-> $json');
    });
    portone.setDBTDetailsListener(callback: (DBTDetailsResponse response) {
      final json = jsonEncode(response);
      print('CHAI_DBTDetails-> $json');
    });

    portone.setAddCustomerListener(callback: (AddCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_AddCustomer-> $json');
    });

    portone.setGetCustomerDataListener(
        callback: (GetCustomerDataResponse response) {
      final json = jsonEncode(response);
      print('CHAI_GetCustomer-> $json');
    });

    portone.setListCardsForCustomerListener(
        callback: (ListCardsForCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_ListCustomer-> $json');
    });

    portone.setAddCardForCustomerListener(
        callback: (AddCardForCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_AddCard-> $json');
    });

    portone.setDeleteCardForCustomerListener(
        callback: (GenericResponse response) {
      final json = jsonEncode(response);
      print('CHAI_DeleteCard-> $json');
    });

    portone.setCaptureTransactionListener(callback: (GenericResponse response) {
      final json = jsonEncode(response);
      print('CHAI_CapturedTransaction-> $json');
    });

    portone.setRoutesListListener(callback: (RoutesListResponse response) {
      final json = jsonEncode(response);
      print('CHAI_RoutesList-> $json');
    });

    _intentData =
        ReceiveSharingIntent.getTextStream().listen((String deeplink) {
      setState(() {
        print('CHAI_DeepLink-> $deeplink');
        portone.processPaymentStatus(deeplink, requests.environment);
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 60.0),
            child: Column(
              children: [
                const Text(
                  "Welcome to PortOne",
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(15),
                                  right: Radius.circular(15)))),
                      onPressed: () {
                        portone.checkoutUsingWeb(requests.getJWTToken(),
                            requests.clientKey, requests.getRequestBody());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 120,
                        child: Text('Web \nCheckout',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 20, color: Colors.deepOrange))),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(15),
                                  right: Radius.circular(15)))),
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, CheckoutElements.routeName);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => CheckoutElements(
                        //           checkoutRequest:
                        //               requests.getGlobalCheckoutRequest())),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SdkWholeCheckout(
                                  checkoutRequest:
                                      requests.getGlobalCheckoutRequest())),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 120,
                        child: Text('Merchant\'s \nCheckout',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 20, color: Colors.deepOrange))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
