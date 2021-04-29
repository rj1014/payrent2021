import 'dart:convert';

import 'package:badges/badges.dart';
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

  Future<List> getData() async {
    var urls =
        Uri.parse("https://payrent000.000webhostapp.com/getnotiflandlord.php");
    final response = await http.post(urls, body: {});

    setState(() {
      data = json.decode(response.body);
    });

    for (var i = 0; i < data.length; i++) {
      String username = data[i]['username'];
      String totalamount = data[i]['totalamount'];
      String contact = data[i]['contact_number'];
      String duedate = data[i]['duedate'];
      print('${username}');
      const String groupKey = 'com.android.example.WORK_EMAIL';
      const String groupChannelId = 'grouped channel id';
      const String groupChannelName = 'grouped channel name';
      const String groupChannelDescription = 'grouped channel description';
      telephony.sendSms(
          to: "${contact}",
          message:
              "Hello ${username}, Reminding for you billing duedate: ${duedate} Tolal of : ${totalamount}");

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
          'Succesfuly Send sms to: ${username}',
          'Duedate: ${duedate} Billing: ${totalamount}',
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

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text("LandLord"),
          centerTitle: true,
          automaticallyImplyLeading: false),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => room()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 80,
                            child: FaIcon(
                              FontAwesomeIcons.houseUser,
                              size: 60,
                              color: Colors.black,
                            )),
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
                                  builder: (context) => report()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 80,
                            child: FaIcon(
                              FontAwesomeIcons.cashRegister,
                              size: 60,
                              color: Colors.black,
                            )),
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ladlordviewacc()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 80,
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              size: 60,
                              color: Colors.black,
                            )),
                      ),
                      Text(
                        'View Accounts',
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
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => landlordnotif()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 80,
                            child: Badge(
                                // ignore: unnecessary_brace_in_string_interps
                                badgeContent: Text(
                                  notf,
                                  style: TextStyle(fontSize: 20),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.bell,
                                  size: 60,
                                  color: Colors.black,
                                ))),
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
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginPage()));
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            radius: 80,
                            child: FaIcon(
                              FontAwesomeIcons.signOutAlt,
                              size: 60,
                              color: Colors.black,
                            )),
                      ),
                      Text(
                        'Logout',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
