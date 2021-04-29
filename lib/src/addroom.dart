import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class adroom extends StatefulWidget {
  adroomState createState() => adroomState("");
  String type;
  adroom({this.type});
}

class adroomState extends State<adroom> {
  String type;
  String id;
  bool loading = false;
  adroomState(this.type);
  final _formKey = GlobalKey<FormState>();
  TextEditingController roomno = TextEditingController();
  TextEditingController monthlyfee = TextEditingController();
  TextEditingController deposit = TextEditingController();
  TextEditingController advance = TextEditingController();
  TextEditingController security = TextEditingController();
  TextEditingController minwaterb = TextEditingController();
  TextEditingController minelectricb = TextEditingController();
  TextEditingController waterread = TextEditingController();
  TextEditingController electricread = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[200],
              title: Text('Add Room'),
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
                                        labelText: 'Pad Number',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: roomno,
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
                                        labelText: 'Monthly Fee',
                                        labelStyle: textStyle,
                                        icon: Icon(Icons.phone,
                                            color: Colors.pink),
                                      ),
                                      cursorColor: Colors.blueAccent,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                      controller: monthlyfee,
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
                                      controller: security,
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
                                      controller: minwaterb,
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
                                      controller: minelectricb,
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
                                      controller: electricread,
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
                                      controller: waterread,
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
    var url = Uri.parse("https://payrent000.000webhostapp.com/addroom.php");
    var result = await http.post(url, body: {
      "roomno": roomno.text,
      "monthlyfee": monthlyfee.text,
      "deposit": deposit.text,
      "advance": advance.text,
      "security": security.text,
      "minwaterb": minwaterb.text,
      "minelectricb": minelectricb.text,
      "waterread": waterread.text,
      "electricread": electricread.text,
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Pad number Exist!"),
            content: new Text("Try another Pad number"),
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
