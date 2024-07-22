import 'package:flutter/material.dart';

class ShippingDetails extends StatelessWidget {
  ShippingDetails({Key? key, required this.address}) : super(key: key);
  late String address;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shipping",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Text(
            address,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
