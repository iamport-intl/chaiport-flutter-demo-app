import 'package:flutter/material.dart';

class EmptyRecordsErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          'OOPS..\nFor NetBanking, \nthere is no viable payment channel',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF444444)
                .withOpacity(0.5), // You can customize the color
          ),
        ),
      ),
    );
  }
}
