import 'package:flutter/material.dart';

class NameLogo extends StatelessWidget {
  NameLogo({Key? key, required this.logo, required this.name})
      : super(key: key);

  late String logo;
  late String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            child: Image.asset(
              logo,
              height: 100,
              width: 100,
            ),
          ),
          Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
