import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class edittenant extends StatefulWidget {
  List list;
  int index;
  String value;
  edittenant({this.list, this.index, this.value});
  @override
  edittenantState createState() => new edittenantState(value);
}

class edittenantState extends State<edittenant> {
  String value;
  List data = [];
  edittenantState(this.value);
  bool loading = false;
  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/gettenant.php");
    final response = await http.post(urls, body: {"username": value});
    return data = json.decode(response.body);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController contactnum = TextEditingController();
  TextEditingController joinfname = TextEditingController();
  TextEditingController joinlname = TextEditingController();
  TextEditingController joinCnum = TextEditingController();
  TextEditingController emailadd = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController barangay = TextEditingController();
  TextEditingController city = TextEditingController();

  @override
  void initState() {
    fname = new TextEditingController(text: widget.list[widget.index]['fname']);
    lname = new TextEditingController(text: widget.list[widget.index]['lname']);
    contactnum = new TextEditingController(
        text: widget.list[widget.index]['contact_number']);
    /*joinfname = new TextEditingController(
        text: widget.list[widget.index]['joinfname']);
    joinlname = new TextEditingController(
        text: widget.list[widget.index]['joinlname']);
    joinCnum = new TextEditingController(
        text: widget.list[widget.index]['joinCnum']);
    emailadd = new TextEditingController(
        text: widget.list[widget.index]['emailadd']);
    street = new TextEditingController(
        text: widget.list[widget.index]['street']);
    barangay = new TextEditingController(
        text: widget.list[widget.index]['barangay']);
    city = new TextEditingController(
        text: widget.list[widget.index]['city']);
    */ // print(productprice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                  ' ${widget.list[widget.index]['fname']} ${widget.list[widget.index]['lname']}'),
              centerTitle: true,
              backgroundColor: Colors.green[200],
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
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter Number';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'First Name',
                                          labelStyle: textStyle,
                                          icon: FaIcon(FontAwesomeIcons.user,
                                              color: Colors.blueGrey),
                                        ),
                                        cursorColor: Colors.blueAccent,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                        controller: fname),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Last Name',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.user,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: lname,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Street',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.home,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: street,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Barangay',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.city,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: barangay,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'City',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.city,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: city,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email Add',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.mailBulk,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: emailadd,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            "   Joiner's Name",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'First Name',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.user,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      controller: joinfname,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Last Name',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.user,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      controller: joinlname,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Contact Number',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.phoneAlt,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                      controller: joinCnum,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, right: 50.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email Add',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.mailBulk,
                                            color: Colors.blueGrey),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: emailadd,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100.0, right: 100.0, top: 10.0),
                                  child: new Container(
                                    child: Material(
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: Colors.green,
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            updtenent();
                                            setState(
                                              () => loading = true,
                                            );
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => loginPage()));
                                          }
                                        },
                                        minWidth: 40.0,
                                        height: 30.0,
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
  }

  void updtenent() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/updateroom.php");
    var result = await http.post(url, body: {
      /* "room_fee": room_fee.text,
      "deposit": deposit.text,
      "advance": advance.text,
      "security_deposit": security_deposit.text,
      "minwaterbill": minwaterbill.text,
      "minelectricbill": minelectricbill.text,
      "initial_water_reading": initial_water_reading.text,
      "initial_electric_reading": initial_electric_reading.text,
    */
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Succesfully Submited"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => landlordhomepages()));
                },
              ),
            ],
          );
        },
      );
    } else {
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
                  setState(
                    () => loading = false,
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}
