import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DatabaseHelper.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Sell/SellProducts.dart';

import '../AllList.dart';
import '../Purchase/PurchaseStock.dart';

class AddItem extends StatefulWidget {

  String screenName;
  AddItem(this.screenName);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  DatabaseHelper db;

  TextEditingController _itemName = TextEditingController();
  TextEditingController _itemPrice = TextEditingController();
  TextEditingController _itemQty = TextEditingController();

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
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
                      controller: _itemName,
                      decoration: InputDecoration(
                        hintText: "Product Name",
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
                        Text("Price"),
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
                      controller: _itemPrice,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
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
                        Text("Quantity"),
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
                      controller: _itemQty,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
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
                  if(_itemName.text.isNotEmpty && _itemPrice.text.isNotEmpty && _itemQty.text.isNotEmpty){
                    db.addProducts(_itemName.text.toString(),
                        _itemPrice.text.toString(), _itemQty.text.toString())
                        .then((value) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Product Added Successfully",
                        buttons: [
                          DialogButton(
                            child: Text("Close",
                                style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                            onPressed: () {
                              if(widget.screenName == "purchase"){
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseStock()));
                              }else if(widget.screenName == "allList"){
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AllList("item")));
                              }else if(widget.screenName == "main"){
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
                  }else{
                    Fluttertoast.showToast(
                        msg: "Enter Product Name, Price and Quantity",
                        textColor: Colors.white,
                        backgroundColor: Colors.grey[600],
                        fontSize: 16.0,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM);
                  }
                },
                child: Text("Add Product"),
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
