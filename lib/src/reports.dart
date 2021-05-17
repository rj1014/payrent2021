import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/src/selectdateforreports.dart';
import 'landloardhome.dart';

class report extends StatefulWidget {
  @override
  reportState createState() => reportState();
}

class reportState extends State<report> {
  bool loading = true;

  List<AllReports> allReports = [];

  double valuePaid = 0.0;
  double valueUnpaid = 0.0;
  double valueRevenue = 0.0;

  @override
  initState() {
    initialLoad();

    super.initState();
  }

  Future getAllReports() async {
    var result = await http.post(
      Uri.parse("https://payrent000.000webhostapp.com/get-all-reports.php"),
      body: {},
    );

    print(result.body);

    return allReportsFromJson(result.body);
  }

  initialLoad() async {
    allReports = await getAllReports();
    var totalPaid = await calculatePaid();
    var totalUnpaid = await calculateUnpaid();
    setState(() {
      valuePaid = totalPaid;
      valueUnpaid = totalUnpaid;
      valueRevenue = valuePaid;
      loading = false;
    });
  }

  calculatePaid() async {
    var total = 0.0;
    for (int x = 0; x < allReports.length; x++) {
      if (allReports[x].status == "paid") {
        total = total + double.parse(allReports[x].totalamount);
      }
    }
    print("Paid $total");
    return total;
  }

  calculateUnpaid() async {
    var total = 0.0;
    for (int x = 0; x < allReports.length; x++) {
      if (allReports[x].status == "unpaid") {
        total = total + double.parse(allReports[x].totalamount);
      }
    }
    print("Unpaid $total");
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text("Reports"),
              centerTitle: true,
            ),
            bottomNavigationBar: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () async {
                      // showDialog(
                      //   barrierDismissible: false,
                      //   context: context,
                      //   builder: (context) {
                      //     return Center(
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width * 0.90,
                      //         color: Colors.white,
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Text(
                      //               'Total Paid Amount: P $valuePaid',
                      //               style: TextStyle(
                      //                 fontSize: 15,
                      //               ),
                      //             ),
                      //             MaterialButton(
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //               child: Text("Close"),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DateReports()));
                    },
                    child: Text('Custom Report'),
                  ),
                  // MaterialButton(
                  //   color: Colors.red,
                  //   onPressed: () async {
                  //     showDialog(
                  //       barrierDismissible: false,
                  //       context: context,
                  //       builder: (context) {
                  //         return Center(
                  //           child: Container(
                  //             width: MediaQuery.of(context).size.width * 0.90,
                  //             color: Colors.white,
                  //             child: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   'Total Unpaid Amount: P $valueUnpaid',
                  //                   style: TextStyle(
                  //                     fontSize: 15,
                  //                   ),
                  //                 ),
                  //                 MaterialButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   child: Text("Close"),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Text('Unpaid'),
                  // ),
                  // MaterialButton(
                  //   color: Colors.blue,
                  //   onPressed: () async {
                  //     showDialog(
                  //       barrierDismissible: false,
                  //       context: context,
                  //       builder: (context) {
                  //         return Center(
                  //           child: Container(
                  //             width: MediaQuery.of(context).size.width * 0.90,
                  //             color: Colors.white,
                  //             child: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Text(
                  //                   'Total Revenue: $valueRevenue',
                  //                   style: TextStyle(
                  //                     fontSize: 15,
                  //                   ),
                  //                 ),
                  //                 MaterialButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   child: Text("Close"),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Text('Total Revenue'),
                  // ),
                ],
              ),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                    ),
                    accountName: Text(""),
                    accountEmail: Text("Username: Landlord"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.green[200]
                              : Colors.white,
                      child: Text(
                        "P",
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.home),
                    title: Text('Home Page'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new landlordhomepages()));
                    },
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.powerOff),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new loginPage()));
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey[600],
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("img/assets/bg.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.3), BlendMode.dstATop),
                ),
              ),
              child: ListView.builder(
                itemCount: allReports.length,
                itemBuilder: (context, index) {
                  // return Container(
                  //   // child: Text("Test"),

                  // );
                  return Card(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Pad Number : ${allReports[index].roomno}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Name : ${allReports[index].fname} ${allReports[index].lname}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "DueDate : ${allReports[index].duedate}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Status: ${allReports[index].status}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Rent Fee : ${allReports[index].rentfee}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Water Bill : ${allReports[index].waterbill}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Electric Bill : ${allReports[index].electricbill}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Total :  ${allReports[index].totalamount}",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}

// class ItemList extends StatelessWidget {
//   final List list;

//   String value;
//   ItemList({this.list, this.value});

//   @override
//   Widget build(BuildContext context) {
//     return new ListView.builder(
//       itemCount: list == null ? 0 : list.length,
//       itemBuilder: (context, i) {
//         return new Container(
//           child: new Card(
//               color: Colors.green[50],
//               child: Column(
//                 children: [
//                   Center(
//                       child: Container(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           children: <Widget>[
//                             Text(
//                               "Pad Number : ${list[i]['room_no']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   DueDate : ${list[i]['date_occupancy']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   Status  : ${list[i]['status']}",
//                               style: TextStyle(
//                                   fontSize: 15, color: Colors.redAccent),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: <Widget>[
//                             Text(
//                               "Name : ${list[i]['fname']} ${list[i]['lname']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   Water Bill  : ${list[i]['waterbill']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "Electric Bill : ${list[i]['electricbill']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "        Total : ${list[i]['totalamount']}",
//                               style: TextStyle(
//                                   fontSize: 20, color: Colors.blueAccent),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )),
//                 ],
//                 crossAxisAlignment: CrossAxisAlignment.start,
//               )),
//         );
//       },
//     );
//   }
// }

// class report extends StatefulWidget {
//   reportState createState() => reportState();

//   List list;
//   int index;
//   bool loading = false;
//   String userid;
//   String path;
// }

// // ignore: camel_case_types
// class reportState extends State<report> {
//   List data = [];
//   String userid;

//   Future<List> getData() async {
//     var urls = Uri.parse("https://payrent000.000webhostapp.com/gettenant.php");
//     final response = await http.post(urls, body: {});
//     return data = json.decode(response.body);
//   }

//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green[200],
//           title: Text("Reports"),
//           centerTitle: true,
//         ),
//         drawer: Drawer(
//           // Add a ListView to the drawer. This ensures the user can scroll
//           // through the options in the drawer if there isn't enough vertical
//           // space to fit everything.

//           child: ListView(
//             // Important: Remove any padding from the ListView.
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               UserAccountsDrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Colors.green[200],
//                 ),
//                 accountName: Text(""),
//                 accountEmail: Text("Username: Landlord"),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundColor:
//                       Theme.of(context).platform == TargetPlatform.iOS
//                           ? Colors.green[200]
//                           : Colors.white,
//                   child: Text(
//                     "P",
//                     style: TextStyle(fontSize: 40.0),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: FaIcon(FontAwesomeIcons.home),
//                 title: Text('Home Page'),
//                 onTap: () {
//                   // Update the state of the app
//                   // ...
//                   // Then close the drawer
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => new landlordhomepages()));
//                 },
//               ),
//               ListTile(
//                 leading: FaIcon(FontAwesomeIcons.powerOff),
//                 title: Text('Logout'),
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => new loginPage()));
//                 },
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: Colors.grey[600],
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("img/assets/bg.jpeg"),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(
//                   Colors.grey.withOpacity(0.3), BlendMode.dstATop),
//             ),
//           ),
//           child: FutureBuilder<List>(
//             future: getData(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) print(snapshot.error);

//               return snapshot.hasData
//                   ? new ItemList(
//                       list: snapshot.data,
//                     )
//                   : new Container(
//                       color: Colors.green[200],
//                       child: Center(
//                         child: SpinKitWave(
//                           color: Colors.green[600],
//                         ),
//                       ));
//             },
//           ),
//         ));
//   }
// }

// class ItemList extends StatelessWidget {
//   final List list;

//   String value;
//   ItemList({this.list, this.value});

//   @override
//   Widget build(BuildContext context) {
//     return new ListView.builder(
//       itemCount: list == null ? 0 : list.length,
//       itemBuilder: (context, i) {
//         return new Container(
//           child: new Card(
//               color: Colors.green[50],
//               child: Column(
//                 children: [
//                   Center(
//                       child: Container(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Column(
//                           children: <Widget>[
//                             Text(
//                               "Pad Number : ${list[i]['room_no']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   DueDate : ${list[i]['date_occupancy']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   Status  : ${list[i]['status']}",
//                               style: TextStyle(
//                                   fontSize: 15, color: Colors.redAccent),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: <Widget>[
//                             Text(
//                               "Name : ${list[i]['fname']} ${list[i]['lname']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "   Water Bill  : ${list[i]['waterbill']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "Electric Bill : ${list[i]['electricbill']}",
//                               style: TextStyle(fontSize: 15),
//                             ),
//                             Text(
//                               "        Total : ${list[i]['totalamount']}",
//                               style: TextStyle(
//                                   fontSize: 20, color: Colors.blueAccent),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )),
//                 ],
//                 crossAxisAlignment: CrossAxisAlignment.start,
//               )),
//         );
//       },
//     );
//   }
// }

// To parse this JSON data, do
//
//     final allReports = allReportsFromJson(jsonString);

// import 'dart:convert';

List<AllReports> allReportsFromJson(String str) =>
    List<AllReports>.from(json.decode(str).map((x) => AllReports.fromJson(x)));

String allReportsToJson(List<AllReports> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllReports {
  AllReports({
    this.billid,
    this.userid,
    this.username,
    this.duedate,
    this.status,
    this.waterbill,
    this.rentfee,
    this.electricbill,
    this.totalamount,
    this.fname,
    this.lname,
    this.roomno,
  });

  String billid;
  String userid;
  String username;
  String duedate;
  String status;
  String waterbill;
  String rentfee;
  String electricbill;
  String totalamount;
  String fname;
  String lname;
  String roomno;

  factory AllReports.fromJson(Map<String, dynamic> json) => AllReports(
        billid: json["billid"],
        userid: json["userid"],
        username: json["username"],
        duedate: json["duedate"],
        status: json["status"],
        waterbill: json["waterbill"],
        rentfee: json["rentfee"],
        electricbill: json["electricbill"],
        totalamount: json["totalamount"],
        fname: json["fname"],
        lname: json["lname"],
        roomno: json["roomno"],
      );

  Map<String, dynamic> toJson() => {
        "billid": billid,
        "userid": userid,
        "username": username,
        "duedate": duedate,
        "status": status,
        "waterbill": waterbill,
        "rentfee": rentfee,
        "electricbill": electricbill,
        "totalamount": totalamount,
        "fname": fname,
        "lname": lname,
        "roomno": roomno,
      };
}

// enum Status { PAID, UNPAID }

// final statusValues = EnumValues({"paid": Status.PAID, "unpaid": Status.UNPAID});

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
