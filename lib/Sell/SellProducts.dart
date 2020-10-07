import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../StockTransactions.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddCustomer.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/Utils.dart';

import '../Utils/DatabaseHelper.dart';

class SellProducts extends StatefulWidget {
  @override
  _SellProductsState createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  DatabaseHelper db;
  Utils dl;
  int _count = 0;
  int ledgerId = 0;
  int productId = 0;
  double productQty = 0.0;
  double productPrice = 0.0;
  double productTotal = 0.0;
  double productGst = 0.0;
  double productGrandTotal = 0.0;
  String sellDate = "";

  String customerName;
  List<DropdownMenuItem<String>> customerList;

  String itemName;
  List<DropdownMenuItem<String>> itemList;

  TextEditingController _itemPrice = TextEditingController();
  TextEditingController _itemQty = TextEditingController();

  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.bold);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db = DatabaseHelper.instance;
    dl = Utils();
    itemList = [];
    customerList = [];

    _getDetails();
  }

  void _getDetails() {
    db.getLedgers("2").then((value) {
      value.map((e) {
        print("Customer: ::: : " + e.toString());
        return dl.getDropdownList(e, "ledger_name");
      }).forEach((element) {
        customerList.add(element);
      });
      setState(() {});
    });

    db.getProducts().then((value) {
      value.map((e) {
        print("Item: ::: : " + e.toString());
        return dl.getDropdownList(e, "product_name");
      }).forEach((element) {
        itemList.add(element);
      });
      setState(() {});
    });
  }

  void _getLedgerId(String ledgerType) {
    db.getLedgers(ledgerType).then((value) {
      value.forEach((element) {
        if (element['ledger_name'].toString() == customerName.toString()) {
          print(element.toString());
          print(element['ledger_id'].toString());
          print(customerName);
          setState(() {
            ledgerId = element['ledger_id'];
            setState(() {});
            print(ledgerId.toString());
          });
        }
      });
    });
  }

  void _getProductDetails() {
    db.getProducts().then((value) {
      value.forEach((element) {
        if (element['product_name'].toString() == itemName.toString()) {
          print(element.toString());
          print(element['product_id'].toString());
          print(itemName);
          setState(() {
            productId = element['product_id'];
            setState(() {});
            print("Product ID : " + productId.toString());
            productPrice = double.parse(element['product_price']);
            setState(() {});
            productQty = double.parse(element['product_qty']);
            setState(() {});
          });
          setState(() {});
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(onSelected: _selected,
            itemBuilder: (BuildContext context) {
              return {'All Sell'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text("Customer", style: _textStyle,),
                      Expanded(
                          child: Text(
                            ":", style: _textStyle,
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                    width: 10
                ),
                Expanded(
                  child: DropdownButton<String>(
                      hint: Text("Select Customer"),
                      value: customerName,
                      items: customerList,
                      onChanged: (String value) {
                        setState(() {
                          customerName = value;
                          _getLedgerId("2");
                        });
                      }),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text("Item", style: _textStyle,),
                      Expanded(
                          child: Text(
                            ":", style: _textStyle,
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                    width: 10
                ),
                Expanded(
                  child: DropdownButton<String>(
                      hint: Text("Select Item"),
                      value: itemName,
                      items: itemList,
                      onChanged: (String value) {
                        setState(() {
                          itemName = value;
                          _getProductDetails();
                          _itemPrice.text = productPrice.toString();
                        });
                      }),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "Price",
                        style: _textStyle,
                      ),
                      Expanded(
                          child: Text(
                            ":",
                            style: _textStyle,
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
                      hintText: "Item Price",
                      // border: InputBorder.none
                    ),
                    onChanged: (value) {
                      setState(() {
                        productPrice = double.parse(value);
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "Quantity",
                        style: _textStyle,
                      ),
                      Expanded(
                          child: Text(
                            ":",
                            style: _textStyle,
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
                      hintText: "Item Quantity",
                      // border: InputBorder.none
                    ),
                    onChanged: (value) {
                      print("QTY : " + value.toString());
                      // print("QTY : " +_itemQty.toString());
                      setState(() {
                        if (_itemQty.text.isEmpty) {
                          productTotal = 0.0;
                          productGst = 0.0;
                          productGrandTotal = 0.0;
                        } else {
                          if (double.parse(_itemQty.text.toString()) <=
                              productQty) {
                            productTotal = productPrice * double.parse(value);
                            productGst = productTotal * 18.0 / 100;
                            productGrandTotal = productTotal + productGst;
                            print(productGrandTotal.toString());
                          } else {
                            setState(() {
                              _itemQty.text = productQty.round().toString();
                              Fluttertoast.showToast(
                                  msg: "Only $productQty pcs left in stock...",
                                  fontSize: 16.0,
                                  backgroundColor: Colors.grey[600],
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM);
                            });
                          }
                        }
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "Total",
                        style: _textStyle,
                      ),
                      Expanded(
                          child: Text(
                            ":",
                            style: _textStyle,
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(productTotal.toString()),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "GST 18%",
                        style: _textStyle,
                      ),
                      Expanded(
                          child: Text(
                            ":",
                            style: _textStyle,
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(productGst.toString()),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "Grand Total",
                        style: _textStyle,
                      ),
                      Expanded(
                          child: Text(
                            ":",
                            style: _textStyle,
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(productGrandTotal.toString()),
                )
              ],
            ),
            SizedBox(height: 50),
            RaisedButton(
              onPressed: () {
                setState(() {
                  sellDate =
                      DateTime.now().toLocal().toString().substring(0, 19);
                });
                print(sellDate);
                if (customerName.isNotEmpty && itemName.isNotEmpty &&
                    _itemPrice.text.isNotEmpty && _itemQty.text.isNotEmpty) {
                  db.addToSell(
                      ledgerId,
                      productId,
                      sellDate.toString(),
                      productTotal.toString(),
                      productGst.toString(),
                      productGrandTotal.toString(),
                      _itemQty.text.toString());
                } else {
                  print("Enter All Details Correctly");
                }
              },
              child: Text("Sell"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCustomer("sell")));
        },
        child: Icon(Icons.add),
        tooltip: "Add Customer",
      ),
    );
  }

  void _selected(String value) {
    switch (value) {
      case 'All Sell':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StockTransactions("sell")));
        break;
    }
  }
}
