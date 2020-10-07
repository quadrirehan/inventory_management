import 'package:flutter/material.dart';
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
    await db.getCount("purchase").then((count) {
      setState(() {
        _count = count;
      });
      // print("count : :::: : $count");
      // print("_count : :::: : $_count");
    });
  }

  Future<List> _getList() async {
    var data;
    var stockT;
    stockT = await db.getTable("stock_transaction");
    print(stockT.toString());
    data = await db.getTable(widget.transaction);
    print(data.toString());
    // print(data[0]['${widget.list}_name'].toString());
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.transaction.toString() == "purchase"
            ? "All Purchase"
            : "All Sell"),
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
                              child: widget.transaction.toString() == "purchase"
                                  ? ListTile(
                                leading: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(snap.data[index]['purchase_date'].toString().split(" ")[0]),
                                    SizedBox(height: 5,),
                                    Text(snap.data[index]['purchase_date'].toString().split(" ")[1]),
                                  ],
                                ),
                                      title: Text(snap.data[index]
                                              ['purchase_id']
                                          .toString()),
                                      subtitle: Text(snap.data[index]
                                              ['stock_t_id']
                                          .toString()),
                                      trailing: Text(snap.data[index]
                                              ['purchase_grand_total']
                                          .toString()),
                                    )
                                  : ListTile(
                                leading: Column(
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(snap.data[index]['sell_date'].toString().split(" ")[0]),
                                    SizedBox(height: 5,),
                                    Text(snap.data[index]['sell_date'].toString().split(" ")[1]),
                                  ],
                                ),
                                title: Text(snap.data[index]['sell_id']
                                          .toString()),
                                      subtitle: Text(snap.data[index]
                                              ['stock_t_id']
                                          .toString()),
                                      trailing: Text(snap.data[index]
                                              ['sell_grand_total']
                                          .toString()),
                                    ));
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
    );
  }
}
