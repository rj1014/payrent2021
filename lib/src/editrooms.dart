import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class editroom extends StatefulWidget {
  List list;
  int index;
  String value;
  editroom({this.list, this.index, this.value});
  @override
  editroomState createState() => new editroomState(value);
}

class editroomState extends State<editroom> {
  String value;
  List data = [];
  editroomState(this.value);
  bool loading = false;
  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/getroom.php");
    final response = await http.post(urls, body: {"room_no": value});
    return data = json.decode(response.body);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController room_fee = TextEditingController();
  TextEditingController initial_electric_reading = TextEditingController();
  TextEditingController initial_water_reading = TextEditingController();
  TextEditingController deposit = TextEditingController();
  TextEditingController advance = TextEditingController();
  TextEditingController security_deposit = TextEditingController();
  TextEditingController minwaterbill = TextEditingController();
  TextEditingController minelectricbill = TextEditingController();

  @override
  void initState() {
    room_fee =
        new TextEditingController(text: widget.list[widget.index]['room_fee']);
    advance =
        new TextEditingController(text: widget.list[widget.index]['advance']);
    deposit =
        new TextEditingController(text: widget.list[widget.index]['deposit']);
    security_deposit = new TextEditingController(
        text: widget.list[widget.index]['security_deposit']);
    minwaterbill = new TextEditingController(
        text: widget.list[widget.index]['minwaterbill']);
    minelectricbill = new TextEditingController(
        text: widget.list[widget.index]['minelectricbill']);
    initial_water_reading = new TextEditingController(
        text: widget.list[widget.index]['initial_water_reading']);
    initial_electric_reading = new TextEditingController(
        text: widget.list[widget.index]['initial_electric_reading']);
    // print(productprice);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Pad Number ${widget.list[widget.index]['room_no']}'),
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
                                          labelText: 'Monthly Fee',
                                          labelStyle: textStyle,
                                          icon: Icon(Icons.phone,
                                              color: Colors.pink),
                                        ),
                                        cursorColor: Colors.blueAccent,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25),
                                        controller: room_fee),
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
                                        labelText: '1 Month Deposit',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: deposit,
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
                                        labelText: '1 Month Advance',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: advance,
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
                                        labelText: 'Security Deposit',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: security_deposit,
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
                                        labelText: 'Minimum Water Bill',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: minwaterbill,
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
                                        labelText: 'Minimum Electric Bill',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: minelectricbill,
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
                                        labelText: 'Initial Electric Reading',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: initial_electric_reading,
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
                                        labelText: 'Initial Water Reading',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: initial_water_reading,
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
                                            add();
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

  void add() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/updateroom.php");
    var result = await http.post(url, body: {
      "room_no": '${widget.list[widget.index]['room_no']}',
      "room_fee": room_fee.text,
      "deposit": deposit.text,
      "advance": advance.text,
      "security_deposit": security_deposit.text,
      "minwaterbill": minwaterbill.text,
      "minelectricbill": minelectricbill.text,
      "initial_water_reading": initial_water_reading.text,
      "initial_electric_reading": initial_electric_reading.text,
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
