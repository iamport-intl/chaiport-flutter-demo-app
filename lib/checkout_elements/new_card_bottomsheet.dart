import 'package:chai_flutter_demo_app/checkout_elements/saved_cards_bottomsheet.dart';
import 'package:portone_flutter_package/dto/requests/chanex_token_request.dart';
import 'package:portone_flutter_package/dto/requests/checkout_global_request.dart';
import 'package:portone_flutter_package/dto/requests/with_tokenization_request.dart';
import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:portone_flutter_package/utility/CardNumberFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portone_flutter_package/utility/MonthYearInputFormatter.dart';

class NewCardBottomsheet extends StatefulWidget {
  PortOneImpl portone;
  double totalAmount;
  String paymentMethodTitle;
  String jwtToken;
  GlobalCheckoutRequest checkoutRequest;

  NewCardBottomsheet({
    Key? key,
    required this.portone,
    required this.totalAmount,
    required this.paymentMethodTitle,
    required this.checkoutRequest,
    required this.jwtToken,
  }) : super(key: key);

  @override
  State<NewCardBottomsheet> createState() => _NewCardBottomsheetState();
}

class _NewCardBottomsheetState extends State<NewCardBottomsheet> {
  bool isChecked = false;
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  String selectedField = "";

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: StatefulBuilder(builder: (context, bottomsheetState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    builder: (context) => SavedCardsBottomSheet(
                        checkoutRequest: widget.checkoutRequest,
                        portone: widget.portone,
                        totalAmount: 20000.00,
                        savedCards: null),
                  );
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset("assets/images/successful-card-payment.png"),
                  const Text(
                    "Get Saved Cards Now",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.deepOrange,
                    size: 20,
                  )
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedField == "name"
                                      ? const Color(0xFFFC6B2D)
                                      : Colors.transparent,
                                  width: 2,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (selectedField == "name")
                                    Image.asset(
                                        "assets/images/polygon-orange.png")
                                  else
                                    Image.asset(
                                        "assets/images/polygon_white.png"),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name",
                                        style: TextStyle(
                                            color: const Color(0xFFAAAAAA),
                                            fontWeight: selectedField == "name"
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: cardHolderNameController,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  selectedField == "name"
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "Cardholder name",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onTap: () {
                                            selectedField = "name";
                                            setState(() {});
                                          },
                                          onSubmitted: (value) {
                                            selectedField = "card_number";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (selectedField == "name")
                                    IconButton(
                                      icon: Image.asset(
                                          'assets/images/cancel_round.png',
                                          package: "portone_flutter_package"),
                                      onPressed: () {
                                        setState(() {
                                          cardHolderNameController.clear();
                                        });
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedField == "card_number"
                                      ? const Color(0xFFFC6B2D)
                                      : Colors.transparent,
                                  width: 2,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (selectedField == "card_number")
                                    Image.asset(
                                        "assets/images/polygon-orange.png")
                                  else
                                    Image.asset(
                                        "assets/images/polygon_white.png"),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Card number",
                                        style: TextStyle(
                                            color: const Color(0xFFAAAAAA),
                                            fontWeight:
                                                selectedField == "card_number"
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  selectedField == "card_number"
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                          controller: cardNumberController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            CardNumberFormatter()
                                          ],
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "XXXX-XXXX-XXXX-XXXX",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onTap: () {
                                            selectedField = "card_number";
                                            setState(() {});
                                          },
                                          onSubmitted: (value) {
                                            selectedField = "month_year";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (selectedField == "card_number")
                                    IconButton(
                                      icon: Image.asset(
                                          'assets/images/cancel_round.png',
                                          package: "portone_flutter_package"),
                                      onPressed: () {
                                        setState(() {
                                          cardNumberController.clear();
                                        });
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedField == "month_year"
                                      ? const Color(0xFFFC6B2D)
                                      : Colors.transparent,
                                  width: 2,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (selectedField == "month_year")
                                    Image.asset(
                                        "assets/images/polygon-orange.png")
                                  else
                                    Image.asset(
                                        "assets/images/polygon_white.png"),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Expires",
                                        style: TextStyle(
                                            color: const Color(0xFFAAAAAA),
                                            fontWeight:
                                                selectedField == "month_year"
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: expiryController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  selectedField == "month_year"
                                                      ? FontWeight.bold
                                                      : FontWeight.normal),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            MonthYearInputFormatter()
                                          ],
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "MM/YYYY",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onTap: () {
                                            selectedField = "month_year";
                                            setState(() {});
                                          },
                                          onSubmitted: (value) {
                                            selectedField = "cvv";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (selectedField == "month_year")
                                    IconButton(
                                      icon: Image.asset(
                                          'assets/images/cancel_round.png',
                                          package: "portone_flutter_package"),
                                      onPressed: () {
                                        setState(() {
                                          expiryController.clear();
                                        });
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selectedField == "cvv"
                                      ? const Color(0xFFFC6B2D)
                                      : Colors.transparent,
                                  width: 2,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (selectedField == "cvv")
                                    Image.asset(
                                        "assets/images/polygon-orange.png")
                                  else
                                    Image.asset(
                                        "assets/images/polygon_white.png"),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cvv",
                                        style: TextStyle(
                                            color: const Color(0xFFAAAAAA),
                                            fontWeight: selectedField == "cvv"
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: cvvController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: selectedField == "cvv"
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(3),
                                          ],
                                          scrollPadding:
                                              const EdgeInsets.only(bottom: 40),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            hintText: "***",
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          onTap: () {
                                            selectedField = "cvv";
                                            setState(() {});
                                          },
                                          onSubmitted: (value) {
                                            selectedField = "";
                                            setState(() {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  if (selectedField == "cvv")
                                    IconButton(
                                      icon: Image.asset(
                                          'assets/images/cancel_round.png',
                                          package: "portone_flutter_package"),
                                      onPressed: () {
                                        setState(() {
                                          cvvController.clear();
                                        });
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: const Color(0xFFFC6B2D),
                                  value: isChecked,
                                  shape: const CircleBorder(),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Remember my card for next purchases",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFFFC6B2D)),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF9F9F9F), blurRadius: 8)
                                ]),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/shield.png",
                                    package: "portone_flutter_package"),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "Secure payments as per PCI-DSS \nstandards.",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: const Color(0xFFFC6B2D)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                            ElevatedButton(
                              onPressed: () {
                                var parts = expiryController.text.split("/");
                                var cardRequest = ChanexTokenRequest(
                                    cardholderName:
                                        cardHolderNameController.text,
                                    cardNumber: cardNumberController.text,
                                    cardType: "Visa",
                                    expirationMonth: parts.first,
                                    expirationYear: parts.last,
                                    saveCard: isChecked,
                                    serviceCode: cvvController.text);

                                var request = WithTokenizationRequest.fromJson(
                                    widget.checkoutRequest.toJson());
                                widget.portone.checkoutUsingNewCard(
                                    request, cardRequest, widget.jwtToken);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFC6B2D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              child: const FractionallySizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 30),
                                  child: Text(
                                    "Pay Now",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      }),
    );
  }
}
