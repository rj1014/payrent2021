import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/addbill.dart';
import 'package:payrent/src/addroom.dart';
import 'package:payrent/src/currentbills.dart';
import 'package:payrent/src/delete.dart';
import 'package:payrent/src/editrooms.dart';
import 'package:payrent/src/edittenants%20copy.dart';
import 'package:payrent/src/landloardaddtenan.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/src/tenant_history.dart';
import 'package:url_launcher/url_launcher.dart';

import 'landloardhome.dart';

class ladlordviewacc extends StatefulWidget {
  ladlordviewaccState createState() => ladlordviewaccState();

  List list;
  int index;
  bool loading = false;
  String userid;
  String path;
}

// ignore: camel_case_types
class ladlordviewaccState extends State<ladlordviewacc> {
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
          title: Text("Tenants"),
          centerTitle: true,
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
        String numb = '${list[i]['contact_number']}';

        Future<String> usr() async {
          var we = Uri.parse("https://payrent000.000webhostapp.com/seton.php");
          final respnse =
              await http.post(we, body: {"username": '${list[i]['username']}'});
          var myInt = int.parse(respnse.body);
          print(myInt);

          if (myInt == 2) {
            String smstenant = 'sms:$numb?body=text%20message';
            launch(smstenant);
          }
        }

        return new Container(
          child: new Card(
              color: Colors.green[50],
              child: Column(
                children: [
                  Center(
                      child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name : ${list[i]['fname']} ${list[i]['lname']}"),
                        Text("Pad Number : ${list[i]['room_no']}"),
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
                            new RaisedButton.icon(
                                icon: FaIcon(FontAwesomeIcons.pencilAlt),
                                label: new Text("Edit"),
                                color: Colors.green[200],
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new edittenant(
                                                list: list,
                                                index: i,
                                              )));
                                }),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new RaisedButton.icon(
                                icon: FaIcon(FontAwesomeIcons.userAlt),
                                label: new Text("History"),
                                color: Colors.green[300],
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Tenant_history(
                                                list: list,
                                                index: i,
                                              )));
                                }),
                          ],
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new RaisedButton.icon(
                                  icon: FaIcon(FontAwesomeIcons.trashAlt),
                                  label: new Text("Delete"),
                                  color: Colors.red[400],
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new Delete(
                                                  list: list,
                                                  index: i,
                                                )));
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new RaisedButton.icon(
                            icon: FaIcon(FontAwesomeIcons.clock),
                            label: new Text("Current Bill"),
                            color: Colors.red[100],
                            onPressed: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Currentbill(
                                        list: list,
                                        index: i,
                                      )));
                            }),
                      ],
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
        );
      },
    );
  }
}
