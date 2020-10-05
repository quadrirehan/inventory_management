import 'package:flutter/material.dart';
import 'package:stock/Utils/DatabaseHelper.dart';

class ConfirmPurchase extends StatefulWidget {
  @override
  _ConfirmPurchaseState createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
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
    });
  }

  Future<List> _getList() async {
    var data;
    data = await db.getTable("purchase_items");
    return data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _count != 0 ? Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: FutureBuilder(future: _getList(), builder: (context, snap) {
            if (snap.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data.length != 0 ? snap.data.length : 0,
                  itemBuilder: (context, index) {
                    return Container(margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Text(snap.data[index]['p_item_price']),
                      ],
                    ),);
                  });
            }else if(snap.hasError){
              return Center(child: Text("Try Again"),);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },)
        ): Center(child: Text("No Records Found"),),
    );
  }
}
