import 'dart:convert';

import 'package:chai_flutter_demo_app/checkout_elements/sekeleton_components/skeleton_instalment.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/requests/checkout_with_installation_request.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/dto/requests/bank_list_request.dart';
import 'package:portone_flutter_package/dto/responses/bank_list_response.dart';
import 'package:portone_flutter_package/dto/responses/payment_method_response.dart';
import 'package:flutter/material.dart';

class InstalmentBottomSheet extends StatefulWidget {
  PortOneImpl portone;
  double totalAmount;
  String paymentMethodTitle;
  List<PaymentMethod>? paymentMethodList;
  GlobalCheckoutRequest checkoutRequest;

  InstalmentBottomSheet(
      {Key? key,
      required this.portone,
      required this.totalAmount,
      required this.paymentMethodTitle,
      required this.checkoutRequest,
      required this.paymentMethodList})
      : super(key: key);

  @override
  State<InstalmentBottomSheet> createState() => _InstalmentBottomSheetState();
}

class _InstalmentBottomSheetState extends State<InstalmentBottomSheet> {
  String paymentChannel = "";
  String paymentMethod = "";
  List<Content>? bankList = [];
  Terms? selectedTerm;
  Content selectedBank = Content();
  bool isPaymentChannelsLoaded = false;

  @override
  void initState() {
    super.initState();

    for (var obj in widget.paymentMethodList!) {
      if (obj.isEnabled == true && obj.isDefault == true) {
        paymentChannel = obj.paymentChannelKey ?? "";
        paymentMethod = obj.paymentMethodKey ?? "";
      }
    }
    var req = BankListRequest(
        methodKey: paymentMethod,
        iamportKey: widget.checkoutRequest.portOneKey,
        isMerchantSponsored: false,
        overrideDefault: false,
        currency: widget.checkoutRequest.currency,
        amount: widget.totalAmount,
        environment: widget.checkoutRequest.environment);
    widget.portone.getBankList(paymentChannel, req);
    final json = jsonEncode(req);
    widget.portone.setBankListListener(callback: (BankListResponse response) {
      print('PortOne_Response-> $response');
      bankList = response.content;
      setState(() {
        isPaymentChannelsLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: StatefulBuilder(builder: (context, bottomsheetState) {
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
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
              if (isPaymentChannelsLoaded)
                if (widget.paymentMethodList?.isNotEmpty ?? false)
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(children: [
                      ...List.generate(
                          bankList!.length,
                          (index) => Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black, padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      backgroundColor: const Color(0xFFFCFCFC),
                                    ),
                                    onPressed: () {},
                                    child: Column(
                                      children: [
                                        ExpansionTile(
                                          title: Row(children: [
                                            Image.network(
                                              bankList![index].logo ?? "",
                                              width: 35,
                                              height: 35,
                                            ),
                                            const SizedBox(width: 5),
                                            Flexible(
                                              child: Text(
                                                bankList![index].bankName!,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ]),
                                          children: [
                                            if (bankList![index].terms !=
                                                    null &&
                                                bankList![index]
                                                    .terms!
                                                    .isNotEmpty)
                                              ...List.generate(
                                                  bankList![index]
                                                      .terms!
                                                      .length,
                                                  (index1) => RadioListTile(
                                                        value: bankList![index]
                                                            .terms![index1],
                                                        groupValue:
                                                            selectedTerm,
                                                        title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${bankList![index].terms![index1].month} months",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13,
                                                                        color: Color(
                                                                            0xFFFC6B2D)),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    color: const Color(
                                                                        0xFFE3E3E3),
                                                                    width: 1,
                                                                    height: 11,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "${bankList![index].terms![index1].monthlyAmount}/M",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Color(
                                                                            0xFFFC6B2D)),
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                "${bankList![index].terms![index1].interest}% interest rate",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Color(
                                                                        0xFF06BF88)),
                                                              ),
                                                              Text(
                                                                "Total ${bankList![index].terms![index1].totalAmount}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            13),
                                                              )
                                                            ]),
                                                        activeColor:
                                                            const Color(
                                                                0xFFFC6B2D),
                                                        onChanged:
                                                            (Object? value) {
                                                          setState(() {
                                                            selectedTerm =
                                                                value as Terms?;
                                                            selectedBank =
                                                                bankList![
                                                                    index];
                                                          });
                                                        },
                                                      ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ))
                    ]),
                  ))
                else
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
              else
                Expanded(child: SkeletonInstalment()),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  BankDetails bankDetails = BankDetails(
                      bankCode: selectedBank.bankCode,
                      bankName: selectedBank.bankName,
                      isMerchantSponsored: false,
                      installmentPeriod: InstallmentPeriod(
                          month: selectedTerm?.month,
                          interest: selectedTerm?.interest?.toDouble()));
                  var request = widget.checkoutRequest;
                  final req = CheckoutWithInstallationRequest.fromJson(
                      jsonDecode(jsonEncode(request)));
                  req.bankDetails = bankDetails;
                  req.pmtChannel = paymentChannel;
                  req.pmtMethod = paymentMethod;
                  var json = jsonEncode(req.toJson());
                  widget.portone.checkoutUsingInstallation(req,"");
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
          ),
        );
      }),
    );
  }
}
