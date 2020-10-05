import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stock/AllList.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DatabaseHelper.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Purchase/PurchaseStock.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Sell/SellProducts.dart';

class AddVendor extends StatefulWidget {
  String screenName;

  AddVendor(this.screenName);

  @override
  _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  DatabaseHelper db;

  TextEditingController _vendorName = TextEditingController(text: "");
  TextEditingController _vendorMobile = TextEditingController(text: "");

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
        title: Text("Add Vendor"),
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
                      controller: _vendorName,
                      decoration: InputDecoration(
                        hintText: "Vendor Name",
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
                      controller: _vendorMobile,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Vendor Mobile No.",
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
                  if (_vendorName.text != "" || _vendorMobile.text != "") {
                    print(_vendorName.text);
                    if (_vendorMobile.text.length != 10) {
                      Fluttertoast.showToast(
                          msg: "Enter 10 Digit Mobile Number",
                          textColor: Colors.white,
                          backgroundColor: Colors.grey[600],
                          fontSize: 16.0,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM);
                    } else {
                      db
                          .addLedger(_vendorName.text, 1, _vendorMobile.text, "1")
                          .then((value) {
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Vendor Added Successfully",
                          buttons: [
                            DialogButton(
                              child: Text("Close",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              onPressed: () {
                                if (widget.screenName == "purchase") {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PurchaseStock()));
                                } else if (widget.screenName == "allList") {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AllList("vendor")));
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
                              descStyle: TextStyle(fontSize: 15)),
                        ).show();
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
                child: Text("Add Vendor"),
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
