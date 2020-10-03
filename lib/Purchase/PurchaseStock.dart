import 'package:flutter/material.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddVendor.dart';
import 'package:stock/AllList.dart';
import 'package:stock/Purchase/ConfirmPurchase.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DatabaseHelper.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DropdownListShow.dart';
import 'package:stock/StockTransactions.dart';

class PurchaseStock extends StatefulWidget {
  @override
  _PurchaseStockState createState() => _PurchaseStockState();
}

class _PurchaseStockState extends State<PurchaseStock> {
  DatabaseHelper db;
  DropdownListShow dl;
  int _count = 0;

  String vendorName;
  List<DropdownMenuItem<String>> vendorList;

  String itemName;
  List<DropdownMenuItem<String>> itemList;

  TextEditingController _itemQty = TextEditingController();
  TextEditingController _itemPrice = TextEditingController();

  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.bold);

  int productId;
  String productPrice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db = DatabaseHelper.instance;
    dl = DropdownListShow();
    vendorList = [];
    itemList = [];
    _getDetails();
    _getCount();
  }

  Future<void> _getCount() async {
    await db.getCount("purchase").then((count) {
      setState(() {
        _count = count;
      });
    });
  }

  void _getDetails() async {
    db.getLedgers("1").then((value) {
      value.map((e) {
        print("Vendor: ::: : " + e.toString());
        return dl.getDropdownList(e, 'ledger_name');
      }).forEach((item) {
        vendorList.add(item);
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

  int _getLedgerDetails(String ledgerType) {
    int ledgerId;
    db.getLedgers(ledgerType).then((value) {
      value.forEach((element) {
        if (element['ledger_name'].toString() == vendorName.toString()) {
          print(element.toString());
          print(element['ledger_id'].toString());
          print(vendorName);
          setState(() {
            ledgerId = element['ledger_id'];
          });
        }
      });
    });
    return ledgerId;
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
            productPrice = element['product_price'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: _selected,
            itemBuilder: (BuildContext context) {
              return {'All Purchase'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Container(
                  width: 105,
                  child: Row(
                    children: [
                      Text(
                        "Vendor",
                        softWrap: true,
                        style: _textStyle,
                      ),
                      Expanded(
                        child: Text(
                          ":",
                          style: _textStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<String>(
                      hint: Text("Select Vendor"),
                      value: vendorName,
                      items: vendorList,
                      onChanged: (String value) {
                        setState(() {
                          vendorName = value;
                          _getLedgerDetails("1");
                          // print("ID: " + data[1]['ledger_id'].toString());
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
                        "Item",
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
                  child: DropdownButton<String>(
                      hint: Text("Select Item"),
                      value: itemName,
                      items: itemList,
                      onChanged: (String value) {
                        setState(() {
                          itemName = value;
                          _getProductDetails();
                          _itemPrice.text = productPrice;
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
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50
            ),
            RaisedButton(
              onPressed: () {
                db.purchaseProduct(_getLedgerDetails("1"), productId, _itemPrice.text, _itemQty.text);
              },
              child: Text("Purchase"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
            SizedBox(
                height: 20
            ),
            RaisedButton(
              onPressed: _count != 0 ? () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmPurchase()));
              } : null,
              child: Text("Confirm Purchase"),
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddVendor("purchase")));
        },
        child: Icon(Icons.add),
        tooltip: "Add Vendor",
      ),
    );
  }

  void _selected(String value) {
    switch (value) {
      case 'All Purchase':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StockTransactions("purchase")));
        break;
    }
  }

}
