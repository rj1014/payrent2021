import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/addbill.dart';
import 'package:payrent/src/editbilling.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:payrent/src/landloardviewaccount.dart';

import 'Login_Page.dart';

class Tenant_history extends StatefulWidget {
  List list;
  int index;
  Tenant_history({this.index, this.list});
  @override
  _Tenant_historyState createState() => new _Tenant_historyState();
}

class _Tenant_historyState extends State<Tenant_history> {
  String value;
  List data = [];

  bool loading = false;
  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/gethistory.php");
    final response = await http
        .post(urls, body: {"userid": '${widget.list[widget.index]['userid']}'});
    return data = json.decode(response.body);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text("Billing History: "
                  '${widget.list[widget.index]['username']}'),
              centerTitle: true,
            ),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.

              child: ListView(
                // Important: Remove any padding from the ListView.
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
                      // Update the state of the app
                      // ...
                      // Then close the drawer
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
              child: FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? new ItemList(
                          list: snapshot.data,
                        )
                      : new Container(
                          color: Colors.green[100],
                          child: Center(
                            child: SpinKitWave(
                              color: Colors.green[600],
                            ),
                          ));
                },
              ),
            ));
  }
}

class ItemList extends StatelessWidget {
  final List list;
  String value;
  ItemList({this.list, this.value});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new Card(
              color: Colors.green[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: <Widget>[
                            Text(
                              "Billing Id : ${list[i]['billid']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   DueDate : ${list[i]['duedate']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   Status  : ${list[i]['status']}",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.redAccent),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "     Rent Fee : ${list[i]['rentfee']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   Water Bill : ${list[i]['waterbill']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Electric Bill : ${list[i]['electricbill']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "        Total : ${list[i]['totalamount']}",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueAccent),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RaisedButton.icon(
                                icon: FaIcon(FontAwesomeIcons.wallet),
                                label: new Text("Mark as Paid"),
                                color: Colors.green[600],
                                onPressed: () {
                                  markpaid(list: list, i: i, context: context);
                                }),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RaisedButton.icon(
                                icon: FaIcon(FontAwesomeIcons.receipt),
                                label: new Text("Check The Reciept"),
                                color: Colors.blue[400],
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text(
                                            "Receipt for Billing id: ${list[i]['billid']}"),
                                        // content: new Text("Total Billing: " '$total'),
                                        actions: <Widget>[
                                          Column(children: <Widget>[
                                            Container(
                                                height: 450,
                                                width: 450,
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Image.network(
                                                    'https://payrent000.000webhostapp.com/upload/' +
                                                        '${list[i]['billid']}.jpg',
                                                    fit: BoxFit.cover)),
                                            // usually buttons at the bottom of the dialog

                                            Container(
                                                child: Row(
                                              children: <Widget>[
                                                Center(
                                                  child: FlatButton(
                                                    child: new Text("Close"),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ))
                                          ]),
                                        ],
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
        );
      },
    );
  }

  void markpaid({list, i, context}) async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/paidbill.php");
    var result = await http.post(url, body: {
      "billid": '${list[i]['billid']}',
      "status": '${list[i]['status']}',
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 2) {
      // ignore: missing_required_param
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Succesfully Submited"),
            // content: new Text("Total Billing: " '$total'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new ladlordviewacc()));
                },
              ),
            ],
          );
        },
      );
    } else {
      // ignore: missing_required_param
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Erro Connection."),
            content: new Text("Try again."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
