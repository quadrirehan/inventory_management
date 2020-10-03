import 'package:flutter/material.dart';

class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Receipt"), centerTitle: true,),
      body: Center(
        child: Text("Receipt"),
      ),
    );
  }
}
