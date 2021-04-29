import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class ladlordadd extends StatefulWidget {
  final List list;
  final int index;
  String value;

  ladlordadd({this.list, this.index, this.value});

  @override
  _ladlordaddState createState() => new _ladlordaddState(this.value);
}

class _ladlordaddState extends State<ladlordadd> {
  String type;
  String id;
  String value;
  List data = [];
  bool loading = false;
  _ladlordaddState(this.type);
  DateTime _date = new DateTime.now();
  DateTime _datetext = DateTime.now();
  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/getroom.php");
    final response = await http.post(urls, body: {"room_no": value});
    return data = json.decode(response.body);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController room_no = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController contact_num = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController date_occupancy = TextEditingController();
  @override
  void initState() {
    room_no =
        new TextEditingController(text: widget.list[widget.index]['room_no']);
    // print(productprice);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2019, 1, 1),
      lastDate: new DateTime(2022, 1, 1),
    );

    if (picked != null && picked != _date) {
      print("Date selected: ${_date.year}/${_date.month}/${_date.day}");
      setState(() {
        _date = picked;
        String b = ("${_date.year}/${_date.month}/${_date.day}");
        date_occupancy.text = b.toString();
        print(date_occupancy.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat("dd/MM/yyyy");
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text('Pad Number ${widget.list[widget.index]['room_no']}'),
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
                                    height: 40.0,
                                    child: TextFormField(
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          date_occupancy.text =
                                              _datetext.toString();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Date Occupamncy",
                                        labelStyle: textStyle,
                                        icon: FaIcon(
                                          FontAwesomeIcons.calendarAlt,
                                          color: Colors.white,
                                        ),
                                      ),
                                      controller: date_occupancy,
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
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'First Name',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.person,
                                            color: Colors.green[600]),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: firstname,
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
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Last Name',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.person,
                                            color: Colors.green[600]),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: lastname,
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
                                          return 'Enter your UserName';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'UserName',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.supervised_user_circle,
                                            color: Colors.blue),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: username,
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
                                          return 'Enter your Contact Number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Contact Number',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: contact_num,
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
                                        if (value.length < 8) {
                                          if (value.isEmpty) {
                                            return 'Password is empty';
                                          } else {
                                            return 'Atleast 8 character';
                                          }
                                        }

                                        return null;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.vpn_key,
                                            color: Colors.red),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: password,
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
                                          'Add',
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
    var url = Uri.parse("https://payrent000.000webhostapp.com/addtenant.php");
    var result = await http.post(url, body: {
      "room_no": '${widget.list[widget.index]['room_no']}',
      "fname": firstname.text,
      "lname": lastname.text,
      "contact_number": contact_num.text,
      "password": password.text,
      "username": username.text,
      "date_occupancy": date_occupancy.text,
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Username Exist!"),
            content: new Text("Try another Username"),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Username Exist!"),
            content: new Text("Succesfully Created"),
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
    }
  }
}
