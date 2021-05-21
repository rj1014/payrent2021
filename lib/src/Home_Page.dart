import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/model.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payrent/src/changepass.dart';
import 'package:payrent/src/myhistory.dart';
import 'package:payrent/src/payonline.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class tenanthomepages extends StatefulWidget {
  tenanthomepagesState createState() => tenanthomepagesState(value, valuepa);
  String value;
  String valuepa;
  tenanthomepages({this.value, this.valuepa});
}

// ignore: camel_case_types
class tenanthomepagesState extends State<tenanthomepages> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String value;
  String valuepa;
  List data = [];
  String userid;
  String fname;
  String lname;
  String contact_number;
  String notf = "";
  String landlordnumber = "";

  bool loading = false;
  tenanthomepagesState(this.value, this.valuepa);

  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/getunpaid.php");
    final response = await http.post(urls, body: {"userid": '$userid'});
    // print(response.body);
    return data = json.decode(response.body);
  }

  Future<String> usr() async {
    var we = Uri.parse("https://payrent000.000webhostapp.com/getinfo.php");
    final respnse = await http.post(we, body: {"username": value});
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      userid = '${userlogin.userid}';
      fname = '${userlogin.fname}';
      lname = '${userlogin.lname}';
      contact_number = '${userlogin.contact_number}';
    });
  }

  Future landlordcontact() async {
    var ld =
        Uri.parse("https://payrent000.000webhostapp.com/getlandlordnumber.php");
    final landlordnum = await http.post(ld, body: {});
    print(landlordnum.body);
    setState(() {
      landlordnumber = (landlordnum.body);
    });
  }

  @override
  Future sms() async {
    var wesms = Uri.parse("https://payrent000.000webhostapp.com/getseton.php");
    final responsed = await http.post(wesms, body: {"username": value});

    var myInt = int.parse(responsed.body);
    if (myInt == 2) {
      this.setState(() {
        notf = "!";
      });

      return sms();
    } else if (myInt == 1) {
      this.setState(() {
        notf = "";
      });

      return sms();
    }
  }

  @override
  Future usrsetof() async {
    var we = Uri.parse("https://payrent000.000webhostapp.com/setoff.php");
    final respnse = await http.post(we, body: {"username": value});
    var myInt = int.parse(respnse.body);
    print(myInt);

    if (myInt == 2) {
      String smstenant = 'sms:$landlordnumber?body=text%20message';
      launch(smstenant);
    }
  }

  Future scd() async {
    var url = "https://payrent000.000webhostapp.com/getnotif.php";
    var result = await http.post(url, body: {
      "username": value,
    });
    var re = int.parse(result.body);
    if (re == 2) {
      // print("valid");
      var android = AndroidNotificationDetails(
          'channelId', 'channelName', 'channelDescription');
      var iOS = IOSNotificationDetails();
      var platform = NotificationDetails(android: android, iOS: iOS);
      await flutterLocalNotificationsPlugin.show(
          0, 'REMINDER', 'For Your Payment', platform);
      await Future.delayed(const Duration(seconds: 86400));

      return scd();
    } else {
      // print("invalid");
      await Future.delayed(const Duration(seconds: 30));
      return scd();
    }
  }

  @override
  initState() {
    super.initState();
    getinfo();
    sms();
    landlordcontact();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initsetting = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initsetting);

    scd();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              centerTitle: true,
              title: Text("Account Information"),
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
                    accountName: Text("Name : $fname $lname"),
                    accountEmail: Text("Username: " + value),
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
                    leading: Badge(
                      badgeContent: Text(notf),
                      child: FaIcon(FontAwesomeIcons.bell),
                    ),
                    title: Text('Notification'),
                    onTap: () {
                      usrsetof();
                    },
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.listAlt),
                    title: Text('History'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new Myhistory(value: value)));
                    },
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.key),
                    title: Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Chabngepass(
                                  value: value, valuepa: valuepa)));
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
                  image: AssetImage("img/assets/bg2.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.3), BlendMode.dstATop),
                ),
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                        color: Colors.cyanAccent[100].withOpacity(0.5),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50.0, top: 5.0, bottom: 5.0),
                                      child: Text(
                                        "Full Name :                $fname $lname",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50.0, top: 5.0, bottom: 5.0),
                                      child: Text(
                                        "Account Id :             $userid",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ))),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 100.0,
                                bottom: 5.0),
                            child: Text(
                              "PAYMENT INFORMATION",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.1,
                      color: Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 20.0, bottom: 5.0),
                        child: FutureBuilder<List>(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? new ItemList(
                                    list: snapshot.data,
                                    value: value,
                                    valuepa: valuepa,
                                    // landlordnumber:landlordnumber,
                                    contact_number: contact_number)
                                : new Container(
                                    child: Center(
                                    child: SpinKitWave(
                                      color: Colors.green[600],
                                    ),
                                  ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  String value;
  String valuepa;
  // String numb = "09973584572";
  String contact_number;
  String landlordnumber = "09050382587";
  // ignore: non_constant_identifier_names
  ItemList({this.list, this.value, this.valuepa, this.contact_number});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        Future<String> usrs() async {
          var we = Uri.parse(
              "https://payrent000.000webhostapp.com/setonlanlord.php");
          final respnse = await http.post(we, body: {
            "username": value,
            "contact_number": contact_number,
          });
          var myInt = int.parse(respnse.body);
          print(landlordnumber);

          if (myInt == 2) {
            String smstenant = 'sms:$landlordnumber?body=text%20message';
            launch(smstenant);
          }
          if (myInt == 1) {
            String smstenant = 'sms:$landlordnumber?body=text%20message';
            launch(smstenant);
          }
        }

        return new Container(
          child: new Card(
              color: Colors.grey.withOpacity(0.3),
              child: Column(
                children: [
                  Center(
                      child: Container(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bill id          : ${list[i]['billid']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        Text("Due Date   : ${list[i]['duedate']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        Text("Rent Fee    : ${list[i]['rentfee']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        Text("Electric Bill: ${list[i]['electricbill']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        Text("Water Bill   : ${list[i]['waterbill']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        Text("ToTal          : ${list[i]['totalamount']}",
                            style: TextStyle(
                                fontSize: 20, color: Colors.redAccent))
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 00.0,
                                  bottom: 0.0),
                              child: new RaisedButton.icon(
                                  icon: FaIcon(FontAwesomeIcons.globe),
                                  label: new Text("PAY Online"),
                                  color: Colors.green[50],
                                  onPressed: () {
                                    print('${list[i]['billid']}');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => new uploadrec(
                                                billid: '${list[i]['billid']}',
                                                value: '${list[i]['username']}',
                                                valuepa: valuepa,
                                                amount:
                                                    '${list[i]['totalamount']}')));
                                  }),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 00.0,
                                  bottom: 0.0),
                              child: new RaisedButton.icon(
                                  icon: FaIcon(FontAwesomeIcons.alignLeft),
                                  label: new Text("Other"),
                                  color: Colors.green[50],
                                  onPressed: () {
                                    usrs();
                                  }),
                            )
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
}
