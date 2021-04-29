import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/landloardviewaccount.dart';

import '../model.dart';

class Delete extends StatefulWidget {
  List list;
  int index;
  String value;
  Delete({this.index, this.list, value});
  @override
  _DeleteState createState() => new _DeleteState();
}

class _DeleteState extends State<Delete> {
  String value;
  bool loading = false;

  void deleteData() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/delete.php");
    var result = await http.post(url, body: {
      "userid": '${widget.list[widget.index]['userid']}',
    });
    var re = int.parse(result.body);
    if (re == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("DELETED SUCCESSFULL"),
            content: new Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ladlordviewacc(
                              // value: value,
                              )));
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? loadingPage()
        : Scaffold(
            appBar: new AppBar(
              title: new Text("Delete Tenant"),
              backgroundColor: Colors.green[200],
              centerTitle: true,
            ),
            body: new Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("img/assets/bg.jpeg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: new Center(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Center(
                          child: new Text(
                            "Are you sure to delete.?",
                            style: new TextStyle(
                                fontSize: 30.0, color: Colors.red),
                          ),
                        ))
                      ],
                    ),
                    new Text(
                      "Tenan Name : ${widget.list[widget.index]['fname']} ${widget.list[widget.index]['lname']}",
                      style: new TextStyle(fontSize: 20.0),
                    ),
                    new Text(
                      "Tenant Username : ${widget.list[widget.index]['username']}",
                      style: new TextStyle(fontSize: 18.0),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new RaisedButton.icon(
                          icon: FaIcon(FontAwesomeIcons.times),
                          label: new Text("Cancel"),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        new RaisedButton.icon(
                            icon: FaIcon(FontAwesomeIcons.check),
                            label: new Text("DELETE"),
                            color: Colors.red,
                            onPressed: () {
                              deleteData();
                              setState(
                                () => loading = true,
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
