import 'dart:math';

import 'package:portone_flutter_package/portone_services/portone_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPInput extends StatefulWidget {
  OTPInput({Key? key, required this.portone}) : super(key: key);

  PortOneImpl portone;

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  String mobileNo = "";
  late String otp;
  var otpController = OtpFieldController();
  bool isStepTwo = false;
  bool isEnableFirstNext = false;
  bool isEnableSecondNext = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: !isStepTwo,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text("mobile phone number",
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              IntlPhoneField(
                initialValue: mobileNo,
                decoration: const InputDecoration(
                  fillColor: Color(0xFFFCFCFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFFECECEC)),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  mobileNo = phone.completeNumber;
                  if (phone.isValidNumber()) {
                    setState(() {
                      isEnableFirstNext = true;
                    });
                  } else {
                    setState(() {
                      isEnableFirstNext = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        if (isStepTwo)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("mobile phone number",
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 16,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(mobileNo,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("OTP number",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: InkWell(
                      onTap: () {
                        widget.portone.getOTP(mobileNo);
                        otpController.clear();
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/images/resend.png',
                              package: "portone_flutter_package"),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("OTP Re-send")
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OTPTextField(
                  controller: otpController,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceBetween,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    otp = pin;
                  },
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (isStepTwo) {
                  setState(() {
                    isStepTwo = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isEnableFirstNext) {
                  widget.portone.getOTP(mobileNo);
                  isStepTwo = true;
                  setState(() {});
                }
                if (isStepTwo) {
                  widget.portone
                      .getSavedCards("", "aiHKafKIbsdUJDOb", mobileNo, otp);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFC6B2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
