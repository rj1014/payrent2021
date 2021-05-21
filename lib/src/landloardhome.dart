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

  String countTenant;
  String countRoom;
  String countVacant;
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

  Future<List> getBuildingStatus() async {
    var buildingdata;
    var urls = Uri.parse(
        "https://payrent000.000webhostapp.com/get-building-status.php");
    final response = await http.post(urls, body: {});

    print(response.body);

    setState(() {
      buildingdata = json.decode(response.body);

      countTenant = buildingdata[0]['countTenant'];
      print(buildingdata[0]['countTenant']);
      countRoom = buildingdata[1]['countRoom'];
      print(buildingdata[1]['countRoom']);
      countVacant = buildingdata[2]['countVacant'];
      print(buildingdata[2]['countVacant']);
    });
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

    getBuildingStatus();
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
              leading: FaIcon(FontAwesomeIcons.houseUser),
              title: Text('Rooms'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => room()));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.cashRegister),
              title: Text('Reports'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => report()));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.user),
              title: Text('View Tenants'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ladlordviewacc()));
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.bellSlash),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => landlordnotif()));
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Text("Number of Tenants: $countTenant",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Container(
                child: Text("Rooms: $countRoom",
                    style: TextStyle(fontSize: 19, color: Colors.white)),
              ),
              Container(
                child: Text("Number Of Available Rooms: $countVacant",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Container(
                child: Text("Number of Occupied Rooms: ",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Container(
                child: Text(
                    "Bills Paid Summary for the \n Month of (Current Month&year)",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Container(
                child: Text("Number of Paid Bills: ",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
              Container(
                child: Text("Number of Unpaid Bills: ",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
              Container(
                child: Text("Total Collected Bills: ",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
              Container(
                child: Text("Total of Uncollected Bills: ",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
