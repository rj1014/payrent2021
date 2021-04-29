import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/model.dart';
import 'package:payrent/src/Login_Page.dart';

class Chabngepass extends StatefulWidget {
  final List list;
  final int index;
  String value;
  String valuepa;

  Chabngepass({this.list, this.index, this.value, this.valuepa});

  @override
  _ChabngepassState createState() =>
      new _ChabngepassState(this.value, this.valuepa);
}

class _ChabngepassState extends State<Chabngepass> {
  //date and time
  String value;
  String valuepa;
  String password;
  String username;
  _ChabngepassState(this.value, this.valuepa);

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController newpassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    newpassword = new TextEditingController(text: valuepa);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Change Password'),
              centerTitle: true,
              backgroundColor: Colors.green[200],
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
                          Row(
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
                                        if (value == valuepa) {
                                          return 'password is similar';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'New Password',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.key,
                                            color: Colors.blue),
                                      ),
                                      controller: newpassword,
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
                                          if (value != newpassword.text) {
                                            return 'Password not match';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Re-NewPassword",
                                          icon: FaIcon(FontAwesomeIcons.key,
                                              color: Colors.blue),
                                        )),
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
                                            changpass();
                                            setState(
                                              () => loading = true,
                                            );
                                          }
                                        },
                                        minWidth: 40.0,
                                        height: 30.0,
                                        child: Text(
                                          'Change',
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
                )));
  }

  void changpass() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/changepass.php");
    var result = await http.post(url, body: {
      "newpassword": newpassword.text,
      "username": value,
    });
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Succesfully Update"),
            // content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new loginPage()));
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
            title: new Text("Error Connection."),
            content: new Text("Try again."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
