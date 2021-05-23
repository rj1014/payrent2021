import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/src/landloardviewaccount.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payrent/src/landlordnotif.dart';
import 'package:payrent/src/reports.dart';
import 'package:payrent/src/rooms.dart';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class landlordhomepages extends StatefulWidget {
  landlordhomepagesState createState() => landlordhomepagesState();

  landlordhomepages();
}

// ignore: camel_case_types
class landlordhomepagesState extends State<landlordhomepages> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // List <info>data = [];
  String username;
  String contact_number;
  String totalamount;
  String notf = "";
  List data = [];

  String countTenant;
  String countRoom;
  String countVacant;

  String countPaid;
  String countUnpaid;
  String totalCollected;
  String totalUncollected;

  var dateMonth;
  var dateYear;
  landlordhomepagesState();

  Future sms() async {
    var wesms =
        Uri.parse("https://payrent000.000webhostapp.com/getsetonlandlord.php");
    final responsed = await http.post(wesms, body: {});

    var myInt = int.parse(responsed.body);
    if (myInt >= 1) {
      this.setState(() {
        notf = "!";
      });
      return sms();
    } else {
      this.setState(() {
        notf = "";
      });
      return sms();
    }
  }

  Future<String> usr() async {
    final respnse = await http.post(
        "https://payrent000.000webhostapp.com/getnotiflandlord.php",
        body: {});
    return respnse.body;
  }

  String _message = "";
  final telephony = Telephony.instance;

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  Future<List> getBuildingStatus(var month) async {
    var buildingdata;
    var urls = Uri.parse(
        "https://payrent000.000webhostapp.com/get-building-status.php");
    final response = await http.post(
      urls,
      body: {
        'month': month.toString(),
      },
    );

    print(response.body);

    setState(() {
      buildingdata = json.decode(response.body);

      countTenant = buildingdata[0]['countTenant'];
      countRoom = buildingdata[1]['countRoom'];
      countVacant = buildingdata[2]['countVacant'];

      countPaid = buildingdata[3]['countPaid'];
      countUnpaid = buildingdata[4]['countUnpaid'];
      if (buildingdata[5]['totalCollected'] == null) {
        totalCollected = "0";
      } else {
        totalCollected = buildingdata[5]['totalCollected'];
      }
      if (buildingdata[6]['totalUncollected'] == null) {
        totalUncollected = "0";
      } else {
        totalUncollected = buildingdata[6]['totalUncollected'];
      }
    });

    return data = json.decode(response.body);
  }

  Future<List> getData() async {
    var urls =
        Uri.parse("https://payrent000.000webhostapp.com/getnotiflandlord.php");
    final response = await http.post(urls, body: {});

    setState(() {
      data = json.decode(response.body);
    });

    for (var i = 0; i < data.length; i++) {
      String name = "${data[i]['fanme']} ${data[i]['lname']}";
      String username = data[i]['username'];
      String rentfee = data[i]['rentfee'];
      String waterbill = data[i]['waterbill'];
      String electricbill = data[i]['electricbill'];
      String totalamount = data[i]['totalamount'];
      String contact = data[i]['contact_number'];
      String duedate = data[i]['duedate'];
      String room = data[i]['room_no'];
      const String groupKey = 'com.android.example.WORK_EMAIL';
      const String groupChannelId = 'grouped channel id';
      const String groupChannelName = 'grouped channel name';
      const String groupChannelDescription = 'grouped channel description';
      telephony.sendSms(
          to: "$contact",
          message:
              // "Hello $username, Reminding for you billing duedate: $duedate Tolal of : $totalamount");
              "Hello $name, Reminding for your billing Due Date: $duedate \n Rent Fee: $rentfee \n Electric Bill: $electricbill \n Water Bill: $waterbill \n Total: $totalamount");

      const AndroidNotificationDetails firstNotificationAndroidSpecifics =
          AndroidNotificationDetails(
              groupChannelId, groupChannelName, groupChannelDescription,
              importance: Importance.max,
              priority: Priority.high,
              groupKey: groupKey);
      const NotificationDetails firstNotificationPlatformSpecifics =
          NotificationDetails(android: firstNotificationAndroidSpecifics);
      await flutterLocalNotificationsPlugin.show(
          1,
          // 'Succesfuly Send sms to: $username',
          'Notification sent to: $name',
          'Pad No: $room \n Duedate: $duedate \n Total Payment: $totalamount',
          firstNotificationPlatformSpecifics);
      await Future.delayed(const Duration(seconds: 10));
    }
  }

  @override
  initState() {
    super.initState();
    sms();

    initPlatformState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initsetting = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initsetting);

    dateMonth = DateFormat.MMMM().format(DateTime.now());
    dateYear = DateTime.now().year;

    getBuildingStatus(dateMonth);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text("LandLord"),
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
        body:
            // FutureBuilder<List>(
            //   future: getData(),
            //   builder: (context, snapshot) {
            //     // if (snapshot.hasError) print(snapshot.error);

            //     print(snapshot.data);

            //     return snapshot.hasData
            //         ?

            WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: totalCollected == null
              ? Container(
                  color: Colors.green[200],
                  child: Center(
                    child: SpinKitWave(
                      color: Colors.green[600],
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("img/assets/bg.jpeg"),
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.3),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: MediaQuery.of(context).size.width * 0.20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Tenant",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    "$countTenant",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Rooms",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    "$countRoom",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Vacant",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    "$countVacant",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.width * 0.50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Text(
                                      "$dateMonth $dateYear",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 3,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: MediaQuery.of(context).size.width *
                                        0.165,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "No. of Paid Bills",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "$countPaid",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          // height:
                                          //     MediaQuery.of(context).size.width * 0.165,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.001,
                                          child: Container(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "No. of Unpaid Bills",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "$countUnpaid",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: MediaQuery.of(context).size.width *
                                        0.165,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Total Collected Bills",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "$totalCollected",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          // height:
                                          //     MediaQuery.of(context).size.width * 0.165,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.001,
                                          child: Container(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Total Uncollected Bills",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "$totalUncollected",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => room(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 70,
                                    child: FaIcon(
                                      FontAwesomeIcons.houseUser,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rooms',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => report(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 70,
                                    child: FaIcon(
                                      FontAwesomeIcons.cashRegister,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Reports',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ladlordviewacc(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 70,
                                    child: FaIcon(
                                      FontAwesomeIcons.user,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  'View Tenants',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => landlordnotif(),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green[100],
                                    radius: 70,
                                    child: Badge(
                                      badgeContent: Text(
                                        notf,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.bell,
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Notification',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        )
        // : new Container(
        //     color: Colors.green[200],
        //     child: Center(
        //       child: SpinKitWave(
        //         color: Colors.green[600],
        //       ),
        //     ),
        //   );

        // body: Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("img/assets/bg.jpeg"),
        //       fit: BoxFit.cover,
        //       colorFilter: ColorFilter.mode(
        //           Colors.grey.withOpacity(0.3), BlendMode.dstATop),
        //     ),
        //   ),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             Container(
        //               child: Text("Tenant: $countTenant",
        //                   style: TextStyle(fontSize: 16, color: Colors.white)),
        //             ),
        //             Container(
        //               child: Text("Rooms: $countRoom",
        //                   style: TextStyle(fontSize: 16, color: Colors.white)),
        //             ),
        //             Container(
        //               child: Text("Vacant: $countVacant",
        //                   style: TextStyle(fontSize: 16, color: Colors.white)),
        //             ),
        //           ],
        //         ),
        //         new Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: <Widget>[
        //             Column(
        //               children: <Widget>[
        //                 GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(context,
        //                         MaterialPageRoute(builder: (context) => room()));
        //                   },
        //                   child: CircleAvatar(
        //                       backgroundColor: Colors.green[100],
        //                       radius: 80,
        //                       child: FaIcon(
        //                         FontAwesomeIcons.houseUser,
        //                         size: 60,
        //                         color: Colors.black,
        //                       )),
        //                 ),
        //                 Text(
        //                   'Rooms',
        //                   textAlign: TextAlign.center,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 )
        //               ],
        //             ),
        //             Column(
        //               children: <Widget>[
        //                 GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (context) => report()));
        //                   },
        //                   child: CircleAvatar(
        //                       backgroundColor: Colors.green[100],
        //                       radius: 80,
        //                       child: FaIcon(
        //                         FontAwesomeIcons.cashRegister,
        //                         size: 60,
        //                         color: Colors.black,
        //                       )),
        //                 ),
        //                 Text(
        //                   'Reports',
        //                   textAlign: TextAlign.center,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 )
        //               ],
        //             )
        //           ],
        //         ),
        //         new Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: <Widget>[
        //             Column(
        //               children: <Widget>[
        //                 GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (context) => ladlordviewacc()));
        //                   },
        //                   child: CircleAvatar(
        //                       backgroundColor: Colors.green[100],
        //                       radius: 80,
        //                       child: FaIcon(
        //                         FontAwesomeIcons.user,
        //                         size: 60,
        //                         color: Colors.black,
        //                       )),
        //                 ),
        //                 Text(
        //                   'View Tenants',
        //                   textAlign: TextAlign.center,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 )
        //               ],
        //             ),
        //             Column(
        //               children: <Widget>[
        //                 GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (context) => landlordnotif()));
        //                   },
        //                   child: CircleAvatar(
        //                       backgroundColor: Colors.green[100],
        //                       radius: 80,
        //                       child: Badge(
        //                           // ignore: unnecessary_brace_in_string_interps
        //                           badgeContent: Text(
        //                             notf,
        //                             style: TextStyle(fontSize: 20),
        //                           ),
        //                           child: FaIcon(
        //                             FontAwesomeIcons.bell,
        //                             size: 60,
        //                             color: Colors.black,
        //                           ))),
        //                 ),
        //                 Text(
        //                   'Notification',
        //                   textAlign: TextAlign.center,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ],
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
