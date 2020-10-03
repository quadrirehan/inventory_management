import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddCustomer.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddItem.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddVendor.dart';
import 'package:stock/AllList.dart';
import 'package:stock/Payment.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Purchase/PurchaseStock.dart';
import 'package:stock/Receipt.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Sell/SellProducts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Management"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _selected,
            itemBuilder: (BuildContext context) {
              return {'All Vendors', 'All Customers', 'All Products'}
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseStock()));
                  },
                  child: Text("Purchase"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SellProducts()));
                  },
                  child: Text("Sell"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Receipt()));
                  },
                  child: Text("Receipt"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Payment()));
                  },
                  child: Text("Payment"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddVendor("main")));
                            },
                            child: Text("Add Vendor"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomer("main")));
                            },
                            child: Text("Add Customer"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem("main")));
                            },
                            child: Text("Add Product"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _selected(String value) {
    switch (value) {
      case 'All Vendors':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllList("ledgersV")));
        break;
      case 'All Customers':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AllList("ledgersC")));
        break;
      case 'All Products':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AllList("products")));
        break;
    }
  }
}
