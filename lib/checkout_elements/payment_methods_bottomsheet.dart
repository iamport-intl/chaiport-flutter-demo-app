import 'dart:convert';

import 'package:portone_flutter_package/dto/requests/without_tokenization_request.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:flutter/material.dart';

import 'supporting_components/empty_records_error.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  PaymentMethodBottomSheet(
      {Key? key,
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
  State<PaymentMethodBottomSheet> createState() =>
      _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  PaymentMethod? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethodTitle == "Bank Transfer") {
      var bankTransferList = <PaymentMethod>[];

      for (var obj in widget.paymentMethodList!) {
        if (obj.isEnabled == true && obj.isDefault == true) {
          bankTransferList.add(obj);
        }
      }
      widget.paymentMethodList = bankTransferList;
    }
  }

  setSelectedWallet(PaymentMethod paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: StatefulBuilder(builder: (context, bottomsheetState) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              color: const Color(0xFFD9D9D9),
              height: 3,
              width: 80,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(children: [
                    Text(
                      widget.totalAmount.toString() + " ",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333333)),
                    ),
                    Text(
                      widget.checkoutRequest.currency ?? "",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFDDDDDD)),
                    ),
                  ]),
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
            if (widget.paymentMethodList?.isNotEmpty ?? false)
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                        widget.paymentMethodList!.length,
                        (index) => RadioListTile(
                              value: widget.paymentMethodList![index],
                              groupValue: selectedPaymentMethod,
                              title: Row(children: [
                                if (widget.paymentMethodList![index].logo !=
                                    null)
                                  FadeInImage(
                                    width: 30,
                                    height: 30,
                                    placeholder: const AssetImage(
                                        "assets/images/round_image_placeholder.png",
                                        package: "portone_flutter_package"),
                                    image: NetworkImage(
                                      widget.paymentMethodList![index].logo!,
                                    ),
                                  )
                                else
                                  Image.asset(
                                      'assets/images/round_image_placeholder.png',
                                      package: "portone_flutter_package"),
                                const SizedBox(width: 5),
                                Text(
                                  widget.paymentMethodList![index].displayName!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                )
                              ]),
                              onChanged: (val) {
                                setSelectedWallet(
                                    widget.paymentMethodList![index]);
                                bottomsheetState(() => {});
                              },
                              selected: widget.paymentMethodList![index] ==
                                  selectedPaymentMethod,
                              activeColor: const Color(0xFFFC6B2D),
                            ))
                  ],
                ),
              ))
            else
              EmptyRecordsErrorWidget(),
            const SizedBox(
              height: 5,
            ),
            if (widget.paymentMethodList?.isNotEmpty ?? false)
              ElevatedButton(
                onPressed: () {
                  var request = widget.checkoutRequest;
                  final req = WithoutTokenizationRequest.fromJson(
                      jsonDecode(jsonEncode(request)));
                  req.pmtChannel = selectedPaymentMethod?.paymentChannelKey;
                  req.pmtMethod = selectedPaymentMethod?.paymentMethodKey;
                  widget.portone.checkoutWithoutTokenization(req,"");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC6B2D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                child: const FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Pay Now",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18,color: Colors.white),
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }),
    );
  }
}
