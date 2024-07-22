import 'dart:convert';
import 'package:chai_flutter_demo_app/checkout_elements/cod_bottomsheet.dart';
import 'package:chai_flutter_demo_app/checkout_elements/payment_methods_bottomsheet.dart';
import 'package:chai_flutter_demo_app/checkout_elements/sekeleton_components/skeleton_payment_methods.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:portone_flutter_package/dto/responses/with_tokenization_response.dart';
import 'package:flutter/material.dart';

import 'instalment_bottomsheet.dart';
import 'new_card_bottomsheet.dart';

class PaymentMethods extends StatefulWidget {
  PaymentMethods(
      {Key? key,
      required this.portone,
      required this.checkoutRequest,
      this.jwtToken})
      : super(key: key);

  PortOneImpl portone;
  GlobalCheckoutRequest checkoutRequest;
  String? jwtToken;

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  _PaymentMethodsState();

  List<Content>? savedCards = [];
  List<PaymentMethod> wallets = [];
  List<PaymentMethod> creditDebitCards = [];
  List<PaymentMethod> bankTransfer = [];
  List<PaymentMethod> cod = [];
  List<PaymentMethod> crypto = [];
  List<PaymentMethod> installments = [];
  List<PaymentMethod> netBanking = [];
  List<PaymentMethod> bnpl = [];
  List<PaymentMethod> qrCode = [];

  bool isPaymentStatusLoaded = false;
  bool isCODSelected = false;

  @override
  void initState() {
    super.initState();

    widget.portone.setCheckoutWithTokenizationListener(
        callback: (WithTokenizationResponse response) {
      final json = jsonEncode(response);
      print('portone_Response_CheckoutWithTokenization-> $response--> $json');
    });

    widget.portone.getPaymentMethods(widget.checkoutRequest.portOneKey ?? "",
        widget.checkoutRequest.currency ?? "","");
    widget.portone.setPaymentMethodsListener(
        callback: (PaymentMethodResponse response) {
      final json = jsonEncode(response);
      wallets = response.wallet ?? [];
      creditDebitCards = response.card ?? [];
      bankTransfer = response.bankTransfer ?? [];
      cod = response.cod ?? [];
      crypto = response.crypto ?? [];
      installments = response.installment ?? [];
      bankTransfer = response.bankTransfer ?? [];
      netBanking = response.netBanking ?? [];
      bnpl = response.bnpl ?? [];
      qrCode = response.qrCode ?? [];
      setState(() {
        isPaymentStatusLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a payment option",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isPaymentStatusLoaded)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (wallets.isNotEmpty) ...[
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "Wallets",
                                    paymentMethodList: wallets),
                              );
                            },
                            child: PaymentMethodsCard("Wallets", wallets)),
                      ],
                      if (creditDebitCards.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              for (PaymentMethod card in creditDebitCards) {
                                if (card.subType == "INT_CREDIT_DEBIT_CARD" &&
                                    card.isEnabled == true &&
                                    card.isDefault == true) {
                                  widget.checkoutRequest.pmtChannel =
                                      card.paymentChannelKey;
                                  widget.checkoutRequest.pmtMethod =
                                      card.paymentMethodKey;
                                  showModalBottomSheet<dynamic>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25))),
                                    builder: (context) => NewCardBottomsheet(
                                      paymentMethodTitle: "Credit Card",
                                      portone: widget.portone,
                                      checkoutRequest: widget.checkoutRequest,
                                      totalAmount: 20000.00,
                                      jwtToken: widget.jwtToken ?? "",
                                    ),
                                  );
                                  break;
                                }
                              }
                            },
                            child: PaymentMethodsCard(
                                "Credit/Debit Cards", creditDebitCards))
                      ],
                      if (bankTransfer.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "Bank Transfer",
                                    paymentMethodList: bankTransfer),
                              );
                            },
                            child: PaymentMethodsCard(
                                "Bank Transfer", bankTransfer))
                      ],
                      if (cod.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                // isCODSelected = !isCODSelected;
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25))),
                                  builder: (context) => CODBottomsheet(
                                      portone: widget.portone,
                                      totalAmount: 20000.00,
                                      checkoutRequest: widget.checkoutRequest,
                                      paymentMethodTitle: "COD",
                                      paymentMethodList: cod),
                                );
                              });
                            },
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: Text(
                                    "COD",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Center(
                                  child: Image.network(
                                    cod[0].logo ?? "",
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                                const Spacer(),
                                if (isCODSelected)
                                  Image.asset('assets/images/check_orange.png',
                                      package: "portone_flutter_package"),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ))
                      ],
                      if (crypto.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "Crypto",
                                    paymentMethodList: crypto),
                              );
                            },
                            child: PaymentMethodsCard("Crypto", crypto))
                      ],
                      if (netBanking.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "Net Banking",
                                    paymentMethodList: netBanking),
                              );
                            },
                            child:
                                PaymentMethodsCard("Net Banking", netBanking))
                      ],
                      if (bnpl.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "BNPL",
                                    paymentMethodList: bnpl),
                              );
                            },
                            child: PaymentMethodsCard("BNPL", bnpl))
                      ],
                      if (qrCode.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => PaymentMethodBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodTitle: "QR Code",
                                    paymentMethodList: qrCode),
                              );
                            },
                            child: PaymentMethodsCard("QR Code", qrCode))
                      ],
                      if (installments.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black, padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (context) => InstalmentBottomSheet(
                                    portone: widget.portone,
                                    totalAmount: 20000.00,
                                    paymentMethodTitle: "Instalment",
                                    checkoutRequest: widget.checkoutRequest,
                                    paymentMethodList: installments),
                              );
                            },
                            child: PaymentMethodsCard(
                                "Installments", installments))
                      ],
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
              )
            else
              Expanded(child: SkeletonPaymentMethods())
          ],
        ),
      ),
    );
  }
}

class PaymentMethodsCard extends StatelessWidget {
  PaymentMethodsCard(this.paymentMethodName, this.paymentMethods);

  List<PaymentMethod> paymentMethods;
  String paymentMethodName;

  int getLength() {
    if (paymentMethods.length > 2) {
      return 2;
    } else {
      return paymentMethods.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Text(
            paymentMethodName,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 5),
        ...List.generate(
            getLength(),
            (index) => Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Image.network(
                    paymentMethods[index].logo ?? "",
                    width: 35,
                    height: 35,
                  ),
                )),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios)
      ],
    );
  }
}
