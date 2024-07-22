import 'dart:convert';

import 'package:chai_flutter_demo_app/checkout_elements/otp_input.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/dto/responses/creditcard_details_response.dart';
import 'package:flutter/material.dart';
import 'package:portone_flutter_package/portone_services/preferance_manager.dart';

class SavedCardsBottomSheet extends StatefulWidget {
  SavedCardsBottomSheet(
      {Key? key,
      required this.portone,
      required this.totalAmount,
      required this.checkoutRequest,
      required this.savedCards})
      : super(key: key);

  PortOneImpl portone;
  double totalAmount;
  List<Content>? savedCards;
  GlobalCheckoutRequest checkoutRequest;

  @override
  State<SavedCardsBottomSheet> createState() => _SavedCardsBottomSheetState();
}

class _SavedCardsBottomSheetState extends State<SavedCardsBottomSheet> {
  Content? selectedCard;
  var otp = "";

  @override
  void initState() {
    super.initState();

    getSavedCards();
    widget.portone.setSavedCardsListener(
        callback: (CreditCardDetailsResponse response) {
      print('PortOne_Response-> $response');
      widget.savedCards = response.content;
      PreferenceManager.saveSavedCardsToken(response.token ?? "");
      setState(() {});
    });
  }

  getSavedCards() async {
    var token = await PreferenceManager.getSavedCardToken();
    if (token != null && token.isNotEmpty) {
      widget.portone.getSavedCards("Bearer $token",
          widget.checkoutRequest.portOneKey.toString(), "+919913379694", otp);
    }
  }

  setSelectedCard(Content card) {
    setState(() {
      selectedCard = card;
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
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  children: const [
                    SizedBox(width: 30),
                    Text(
                      "Choose your ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text("Saved Card",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFC6B2D)))
                  ],
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Color(0xFFDDDDDD),
            ),
            if ((widget.savedCards == null ||
                widget.savedCards?.length == 0)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: OTPInput(
                  portone: widget.portone,
                ),
              ),
            ],
            if (widget.savedCards != null && widget.savedCards!.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                          widget.savedCards!.length,
                          (index) => RadioListTile(
                                value: widget.savedCards![index],
                                groupValue: selectedCard,
                                title: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFFECECEC),
                                          width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.savedCards![index]
                                            .partialCardNumber!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF333333)),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Expires",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Color(0xFFAAAAAA)),
                                              ),
                                              Text(
                                                  "${widget.savedCards![index].expiryMonth}/${widget.savedCards![index].expiryYear}",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF333333)))
                                            ],
                                          ),
                                          const SizedBox(width: 12),
                                          Image.asset(
                                            (() {
                                              if (widget.savedCards![index]
                                                      .type ==
                                                  "visa") {
                                                return "assets/images/visa_logo.png";
                                              } else if (widget
                                                      .savedCards![index]
                                                      .type ==
                                                  "mastercard") {
                                                return "assets/images/mastercard-2.png";
                                              } else {
                                                return "assets/images/visa_logo.png";
                                              }
                                            })(),
                                            width: 30,
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                onChanged: (val) {
                                  setSelectedCard(widget.savedCards![index]);
                                  bottomsheetState(() => {});
                                },
                                selected:
                                    widget.savedCards![index] == selectedCard,
                                activeColor: Colors.red,
                              )),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.savedCards != null && widget.savedCards!.isNotEmpty) ...[
              ElevatedButton(
                onPressed: () {
                  if (selectedCard != null) {
                    // var request = requests.getTokenizationRequest();
                    // request.tokenParams!.partialCardNumber =
                    //     selectedCard!.partialCardNumber;
                    // request.tokenParams!.expiryMonth =
                    //     selectedCard!.expiryMonth;
                    // request.tokenParams!.expiryYear = selectedCard!.expiryYear;
                    // request.tokenParams!.token = selectedCard!.token;
                    // request.tokenParams!.type = selectedCard!.type;
                    // final json = jsonEncode(request);
                    // widget.portone.checkoutWithTokenization(request);
                  }
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
            ],
            const SizedBox(
              height: 20,
            ),
          ],
        );
      }),
    );
  }
}
