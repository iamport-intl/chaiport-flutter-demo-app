import 'dart:async';
import 'dart:convert';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/chaiport_services/portone_impl.dart';
import 'package:chaipay_flutter_package/dto/requests/add_customer_request.dart';
import 'package:chaipay_flutter_package/dto/requests/delete_card_request.dart';
import 'package:chaipay_flutter_package/dto/responses/add_card_for_customer_response.dart';
import 'package:chaipay_flutter_package/dto/responses/add_customer_response.dart';
import 'package:chaipay_flutter_package/dto/responses/bank_list_response.dart';
import 'package:chaipay_flutter_package/dto/responses/chanex_token_response.dart';
import 'package:chaipay_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:chaipay_flutter_package/dto/responses/direct_bank_transfer_details_response.dart';
import 'package:chaipay_flutter_package/dto/responses/generic_response.dart';
import 'package:chaipay_flutter_package/dto/responses/get_customer_data_response.dart';
import 'package:chaipay_flutter_package/dto/responses/get_otp_response.dart';
import 'package:chaipay_flutter_package/dto/responses/list_cards_for_customer_response.dart';
import 'package:chaipay_flutter_package/dto/responses/payment_method_response.dart';
import 'package:chaipay_flutter_package/dto/responses/routes_list_response.dart';
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
  late PortOneImpl portone;
  Requests requests = Requests();
  late StreamSubscription _intentData;
  SignatureHash hash = SignatureHash();
  RandomStringsGeneration randomString = RandomStringsGeneration();

  @override
  void initState() {
    super.initState();

    portone = PortOneImpl(
        context, requests.environment, false, requests.devEnvironment);

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
                  portone.getOTP(requests.mobileNo);
                  portone.checkoutUsingWeb(requests.getJWTToken(),
                      requests.clientKey, requests.getRequestBody());
                  portone.getPaymentMethods(
                      requests.clientKey, requests.currency, null);
                  portone.getSavedCards(
                      "", requests.clientKey, requests.mobileNo, "217910");
                  portone.checkoutWithTokenization(
                      requests.getTokenizationRequest(), null);
                  portone.checkoutWithoutTokenization(
                      requests.getWithoutTokenizationRequest(), null);
                  portone.checkoutUsingNewCard(
                      requests.getTokenizationRequest(),
                      requests.getChanexTokenRequest(),
                      requests.getJWTToken());
                  portone.checkoutUsingDirectBankTransfer(
                      requests.getCheckoutWithDirectBankTransferRequest(),
                      null);
                  portone.checkoutUsingInstallation(
                      requests.getCheckoutWithInstallationRequest(), null);
                  portone.getBankList(
                      requests.paymentChannel, requests.getBankListRequest());
                  portone.getDBTDetails(requests.clientKey);
                  portone.addCustomer(
                      requests.getJWTToken(),
                      requests.clientKey,
                      AddCustomerRequest(
                          name: "Aagam",
                          customerRef: randomString.getRandomString(10),
                          emailAddress:
                              randomString.getRandomString(10) + "@gmail.com",
                          phoneNumber: requests.mobileNo));
                  portone.getCustomer(requests.getJWTToken(),
                      requests.clientKey, requests.customerUUID);
                  portone.addCardForCustomer(
                      requests.customerUUID,
                      requests.getJWTToken(),
                      requests.clientKey,
                      requests.getChanexTokenRequest(),
                      null);
                  portone.listCardsForCustomer(requests.customerUUID,
                      requests.getJWTToken(), requests.clientKey);
                  portone.deleteCardForCustomer(
                      requests.customerUUID,
                      requests.getJWTToken(),
                      requests.clientKey,
                      DeleteCardRequest(
                          token: "735eaf72a0a14965aced3e1f9a339b0b"));
                  portone.captureTransaction("2SDCUiBEv34oqeIdEDv1pftGeeY",
                      requests.getJWTToken(), requests.clientKey);
                  portone.getRoutesList(
                      requests.clientKey, requests.getJWTToken());
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
