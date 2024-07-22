import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/requests/without_tokenization_request.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';

class CODBottomsheet extends StatefulWidget {
  CODBottomsheet({Key? key,
    required this.portone,
    required this.totalAmount,
    required this.checkoutRequest,
    required this.paymentMethodTitle,
    this.paymentMethodList})
      : super(key: key);

  PortOneImpl portone;
  double totalAmount;
  List<PaymentMethod>? paymentMethodList;
  String paymentMethodTitle;
  GlobalCheckoutRequest checkoutRequest;

  @override
  State<CODBottomsheet> createState() => _CODBottomsheetState();
}

class _CODBottomsheetState extends State<CODBottomsheet> {
  String paymentChannel = "";
  String paymentMethod = "";

  @override
  void initState() {
    for (var obj in widget.paymentMethodList!) {
      if (obj.isEnabled == true) {
        paymentChannel = obj.paymentChannelKey ?? "";
        paymentMethod = obj.paymentMethodKey ?? "";
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.2,
      child: StatefulBuilder(builder: (context, bottomsheetState) {
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    widget.totalAmount.toString(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF333333)),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    const Text(
                      "Input my ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      widget.paymentMethodTitle,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFC6B2D)),
                    )
                  ],
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Color(0xFFDDDDDD),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/back.png',
                              package: "portone_flutter_package"),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var request = widget.checkoutRequest;
                      final req = WithoutTokenizationRequest.fromJson(
                          jsonDecode(jsonEncode(request)));
                      req.pmtChannel = paymentChannel;
                      req.pmtMethod = paymentMethod;
                      var json = jsonEncode(req);
                      widget.portone.checkoutWithoutTokenization(req,"");
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC6B2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    child: const FractionallySizedBox(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        child: Text(
                          "Pay Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18,color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
