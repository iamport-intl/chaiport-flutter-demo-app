import 'dart:async';
import 'dart:convert';
import 'package:chai_flutter_demo_app/requests/requests.dart';
import 'package:chai_flutter_demo_app/result.dart';
import 'package:chai_flutter_demo_app/utils/random_strings_generation.dart';
import 'package:chai_flutter_demo_app/utils/signature_hash_generation.dart';
import 'package:chaipay_flutter_package/chaiport_services/chaiport_impl.dart';
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
  RandomStringsGeneration randomString = RandomStringsGeneration();

  @override
  void initState() {
    super.initState();

    chai = ChaiPortImpl(
        context, requests.environment, false, requests.devEnvironment);

    chai.setPaymentStatusListener(
        callback: (Map<String, dynamic> paymentStatus) {
      final json = jsonEncode(paymentStatus);
      print('CHAI_PaymentStatus-> $json');
      navigateToResult(paymentStatus);
    });
    chai.setOtpListener(callback: (GetOtpResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setPaymentMethodsListener(callback: (PaymentMethodResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setSavedCardsListener(callback: (CreditCardDetailsResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setCheckoutWithTokenizationListener(
        callback: (WithTokenizationResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setCheckoutWithoutTokenizationListener(
        callback: (WithoutTokenizationResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setTokenCallBackListener(callback: (ChanexTokenResponse response) {
      final json = jsonEncode(response);
      print('CHAI_Response-> $response--> $json');
    });
    chai.setPaymentLinkListener(callback: (String paymentLink) {
      print('CHAI_PaymentLink-> $paymentLink');
    });
    chai.setBankListListener(callback: (BankListResponse response) {
      final json = jsonEncode(response);
      print('CHAI_BankList-> $json');
    });
    chai.setDBTDetailsListener(callback: (DBTDetailsResponse response) {
      final json = jsonEncode(response);
      print('CHAI_DBTDetails-> $json');
    });

    chai.setAddCustomerListener(callback: (AddCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_AddCustomer-> $json');
    });

    chai.setGetCustomerDataListener(
        callback: (GetCustomerDataResponse response) {
      final json = jsonEncode(response);
      print('CHAI_GetCustomer-> $json');
    });

    chai.setListCardsForCustomerListener(
        callback: (ListCardsForCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_ListCustomer-> $json');
    });

    chai.setAddCardForCustomerListener(
        callback: (AddCardForCustomerResponse response) {
      final json = jsonEncode(response);
      print('CHAI_AddCard-> $json');
    });

    chai.setDeleteCardForCustomerListener(callback: (GenericResponse response) {
      final json = jsonEncode(response);
      print('CHAI_DeleteCard-> $json');
    });

    _intentData =
        ReceiveSharingIntent.getTextStream().listen((String deeplink) {
      setState(() {
        print('CHAI_DeepLink-> $deeplink');
        chai.processPaymentStatus(deeplink, requests.environment);
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
                  //     "", requests.clientKey, requests.mobileNo, "217910");
                  // chai.checkoutWithTokenization(
                  //     requests.getTokenizationRequest());
                  // chai.checkoutWithoutTokenization(
                  //     requests.getWithoutTokenizationRequest());
                  // chai.checkoutUsingNewCard(requests.getTokenizationRequest(),
                  //     requests.getChanexTokenRequest(), requests.getJWTToken());
                  // chai.checkoutUsingDirectBankTransfer(
                  //     requests.getCheckoutWithDirectBankTransferRequest());
                  // chai.checkoutUsingInstallation(
                  //     requests.getCheckoutWithInstallationRequest());
                  // chai.getBankList(
                  //     requests.paymentChannel, requests.getBankListRequest());
                  // chai.getDBTDetails(requests.clientKey);
                  // chai.addCustomer(
                  //     requests.getJWTToken(),
                  //     requests.clientKey,
                  //     AddCustomerRequest(
                  //         name: "Aagam",
                  //         customerRef: randomString.getRandomString(10),
                  //         emailAddress:
                  //             randomString.getRandomString(10) + "@gmail.com",
                  //         phoneNumber: requests.mobileNo));
                  // chai.getCustomer(requests.getJWTToken(), requests.clientKey,
                  //     requests.customerUUID);
                  // chai.addCardForCustomer(
                  //     requests.customerUUID,
                  //     requests.getJWTToken(),
                  //     requests.clientKey,
                  //     requests.getChanexTokenRequest());
                  // chai.listCardsForCustomer(requests.customerUUID,
                  //     requests.getJWTToken(), requests.clientKey);
                  chai.deleteCardForCustomer(
                      requests.customerUUID,
                      requests.getJWTToken(),
                      requests.clientKey,
                      DeleteCardRequest(
                          token: "735eaf72a0a14965aced3e1f9a339b0b"));
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
