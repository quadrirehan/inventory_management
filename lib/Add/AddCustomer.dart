import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DatabaseHelper.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Sell/SellProducts.dart';

import '../AllList.dart';

class AddCustomer extends StatefulWidget {
  String screenName;

  AddCustomer(this.screenName);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  DatabaseHelper db;

  TextEditingController _customerName = TextEditingController();
  TextEditingController _customerMobile = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Container(
                    width: 90,
                    child: Row(
                      children: [
                        Text("Name"),
                        Expanded(
                            child: Text(
                          ":",
                          textAlign: TextAlign.right,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _customerName,
                      decoration: InputDecoration(
                        hintText: "Customer Name",
                        // border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 90,
                    child: Row(
                      children: [
                        Text("Mobile No."),
                        Expanded(
                            child: Text(
                          ":",
                          textAlign: TextAlign.right,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _customerMobile,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Customer Mobile No.",
                        // border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                onPressed: () {
                  if (_customerName.text.isNotEmpty &&
                      _customerMobile.text.isNotEmpty) {
                    if (_customerMobile.text.length != 10) {
                       Fluttertoast.showToast(
                          msg: "Enter 10 Digit Mobile Number",
                          textColor: Colors.white,
                          backgroundColor: Colors.grey[600],
                          fontSize: 16.0,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM);
                    } else {
                      db
                          .addLedger(_customerName.text, 2, _customerMobile.text,
                              "2")
                          .then((value) {
                        Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Customer Added Successfully",
                                buttons: [
                                  DialogButton(
                                    child: Text("Close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                    onPressed: () {
                                      if (widget.screenName == "sell") {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SellProducts()));
                                      } else if (widget.screenName ==
                                          "allList") {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AllList("customer")));
                                      } else if (widget.screenName == "main") {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                ],
                                style: AlertStyle(
                                    isCloseButton: false,
                                    isOverlayTapDismiss: false,
                                    descStyle: TextStyle(fontSize: 15)))
                            .show();
                      });
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter Name and Mobile Number",
                        textColor: Colors.white,
                        backgroundColor: Colors.grey[600],
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM);
                  }
                },
                child: Text("Add Customer"),
                color: Colors.blue,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
