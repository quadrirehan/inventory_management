import 'package:flutter/material.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddCustomer.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DropdownListShow.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Purchase/PurchaseStock.dart';

import '../Utils/DatabaseHelper.dart';

class SellProducts extends StatefulWidget {
  @override
  _SellProductsState createState() => _SellProductsState();
}

class _SellProductsState extends State<SellProducts> {
  DatabaseHelper db;
  DropdownListShow dl;

  String customerName;
  List<DropdownMenuItem<String>> customerList;

  String itemName;
  List<DropdownMenuItem<String>> itemList;

  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.bold);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db = DatabaseHelper.instance;
    dl = DropdownListShow();
    itemList = [];
    customerList = [];

    _getDetails();
  }

  void _getDetails() {
    // db.addCustomer("Abdullah", "8855224466");
    // db.addCustomer("Abdul Rehman", "7744112233");
    // db.addCustomer("Areeb", "9876549876");

    // db.getDetails("customer").then((value) {
    //   value.map((e) {
    //     print("aasdsd: ::: : "+e.toString());
    //     return dl.getDropdownList(e, 'customer_name');
    //   }).forEach((item) {customerList.add(item);});
    //   setState(() {});
    // });

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell"),
        centerTitle: true,
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
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<String>(
                      hint: Text("Select Customer"),
                      value: customerName,
                      items: customerList,
                      onChanged: (String value) {
                        setState(() {
                          customerName = value;
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
                        });
                      }),
                )
              ],
            ),
            SizedBox(height: 20)
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
}
