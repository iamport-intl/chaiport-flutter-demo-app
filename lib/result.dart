import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  final Map paymentStatus;

  const Result({Key? key, required this.paymentStatus}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Shop"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 60.0),
          child: Column(
            children: [
              Text(
                widget.paymentStatus.toString(),
                style: const TextStyle(fontSize: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
