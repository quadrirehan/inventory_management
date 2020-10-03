import 'package:flutter/material.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddCustomer.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddItem.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Add/AddVendor.dart';
import 'file:///D:/Rehan/Android/flutter/stock/lib/Utils/DatabaseHelper.dart';

class StockTransactions extends StatefulWidget {
  String transaction;

  StockTransactions(this.transaction);

  @override
  _StockTransactions createState() => _StockTransactions();
}

class _StockTransactions extends State<StockTransactions> {
  DatabaseHelper db;
  int _count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseHelper.instance;
    _getCount();
  }

  Future<void> _getCount() async {
    await db.getCount(widget.transaction).then((count) {
      setState(() {
        _count = count;
      });
      // print("count : :::: : $count");
      // print("_count : :::: : $_count");
    });
  }

  Future<List> _getList() async {
    var data;
    // if(widget.transaction == "ledgersV"){
    //   data = await db.getLedgers("1");
    // }else if(widget.list == "ledgersC"){
    //   data = await db.getLedgers("2");
    // }else{
      data = await db.getTable("purchase_items");
    // }
    // print(data[0]['${widget.list}_name'].toString());
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // title: Text(widget.list.toString() == "ledgersV"
        //     ? "Vendors"
        //     : widget.list.toString() == "ledgersC" ? "Customers" : "Products"),
        centerTitle: true,
      ),
      body: _count != 0
          ? Padding(
              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
              child: FutureBuilder(
                  future: _getList(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Center(child: Text("Try Again"));
                    } else if (snap.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data.length != 0 ? snap.data.length : 0,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: /*widget.list.toString() == "ledgersV"
                                  ? */ListTile(
                                      title: Text(snap.data[index]
                                          ['product_id'].toString()),
                                      subtitle: Text(snap.data[index]
                                          ['p_item_price'].toString()),
                                trailing: Text(snap.data[index]['p_item_qty']),
                                    ));
                                  /*: widget.list.toString() == "ledgersC"
                                      ? ListTile(
                                          title: Text(snap.data[index]
                                              ['ledger_name']),
                                          subtitle: Text(snap.data[index]
                                              ['ledger_mobile']),
                                // trailing: Text(snap.data[index]['customer_balance'] + "/-", style: TextStyle(color: Colors.red),),
                                        )
                                      : ListTile(
                                          title: Text(snap.data[index]
                                              ['product_name']),
                                          subtitle: Text("Quantity : "+snap.data[index]
                                              ['product_qty']),
                                trailing: Text(snap.data[index]['product_price']+"/-"),
                                        ));*/
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          : Center(
              child: Text("No Records Found"),
            ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   if(widget.list == "vendor"){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddVendor("allList")));
      //   }else if(widget.list == "customer"){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomer("allList")));
      //   }else{
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem("allList")));
      //   }
      // }, child: Icon(Icons.add), tooltip: "Add ${widget.list}",),
    );
  }
}
