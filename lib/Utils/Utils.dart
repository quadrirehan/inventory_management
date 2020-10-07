import 'package:flutter/material.dart';

class Utils{
  // DatabaseHelper db = DatabaseHelper.instance;
  //
  // List<DropdownMenuItem<String>> vendorList = [];
  // List<DropdownMenuItem<String>> customerList = [];
  // List<DropdownMenuItem<String>> itemList = [];
  //
  // DropdownListShow(){
  //   vendorList = [];
  //   customerList = [];
  //   itemList = [];
  // }


  // void getDetails(String tableName, String columnName){
  //   db.getDetails(tableName).then((value) {
  //     value.map((e) {
  //       print("$columnName: ::: : "+e.toString());
  //       return getDropdownList(e, columnName);
  //     }).forEach((item) {
  //       if(tableName == "customer"){
  //         customerList.add(item);
  //       }else if(tableName == "vendor"){
  //         vendorList.add(item);
  //         print(vendorList);
  //       }else if(tableName == "item")
  //         itemList.add(item);
  //     });
  //   });
  // }

  DropdownMenuItem<String> getDropdownList(Map<String, dynamic> map, String columnName) {
    return DropdownMenuItem<String>(
      value: map[columnName],
      child: Text(map[columnName]),
    );
  }
}