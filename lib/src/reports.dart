import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/src/Login_Page.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'landloardhome.dart';

class report extends StatefulWidget {
  reportState createState() => reportState();

  List list;
  int index;
  bool loading = false;
  String userid;
  String path;
}

// ignore: camel_case_types
class reportState extends State<report> {
  List data = [];
  String userid;

  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/gettenant.php");
    final response = await http.post(urls, body: {});
    return data = json.decode(response.body);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text("Reports"),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new loginPage()));
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
                      color: Colors.green[200],
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
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new Card(
              color: Colors.green[50],
              child: Column(
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
                              "Pad Number : ${list[i]['room_no']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   DueDate : ${list[i]['date_occupancy']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   Status  : ${list[i]['status']}",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.redAccent),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Name : ${list[i]['fname']} ${list[i]['lname']}",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "   Water Bill  : ${list[i]['waterbill']}",
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
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
        );
      },
    );
  }
}
