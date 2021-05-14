import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:intl/intl.dart';

class Currentbill extends StatefulWidget {
  List list;
  int index;
  String value;
  Currentbill({this.index, this.list, value});
  @override
  _CurrentbillState createState() => new _CurrentbillState();
}

class _CurrentbillState extends State<Currentbill> {
  String value;
  bool loading = false;
  DateTime _date = new DateTime.now();
  DateTime _datetext = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  TextEditingController waterreading = TextEditingController();
  TextEditingController electricreading = TextEditingController();
  TextEditingController duedate = TextEditingController();

  @override
  initState() {
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
        duedate.text = b.toString();
        print(duedate.text);
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
              title: Text(
                  '${widget.list[widget.index]['fname']} ${widget.list[widget.index]['lname']}'),
              centerTitle: true,
            ),
            backgroundColor: Colors.green[200],
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
                      child: Container(
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
                                            duedate.text = _datetext.toString();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Due Date",
                                          labelStyle: textStyle,
                                          icon: FaIcon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        controller: duedate,
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
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          var pNumber = int.tryParse(value);
                                          if (value.isEmpty) {
                                            return 'Amount Required.!';
                                          }
                                          if (pNumber == null) {
                                            return 'Enter Proper Amount.!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Current Water Reading',
                                          labelStyle: textStyle,
                                          icon: FaIcon(
                                              FontAwesomeIcons.handHoldingWater,
                                              color: Colors.blueAccent),
                                        ),
                                        controller: waterreading,
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
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          var pNumber = int.tryParse(value);
                                          if (value.isEmpty) {
                                            return 'Amount Required.!';
                                          }
                                          if (pNumber == null) {
                                            return 'Enter Proper Amount.!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Current Electric Reading',
                                          labelStyle: textStyle,
                                          icon: FaIcon(FontAwesomeIcons.bolt,
                                              color: Colors.yellowAccent),
                                        ),
                                        controller: electricreading,
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
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        color: Colors.green,
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              submitbilling();
                                              setState(
                                                () => loading = true,
                                              );
                                            }
                                          },
                                          minWidth: 40.0,
                                          height: 30.0,
                                          child: Text(
                                            'Submit',
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
                  ),
                )),
          );
  }

  void submitbilling() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/submitbill.php");
    var result = await http.post(url, body: {
      "userid": widget.list[widget.index]['userid'].toString(),
      "currentwaterreading": waterreading.text,
      "currentelectricreading": electricreading.text,
      "duedate": duedate.text,
    });
    print(result.body);
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Bill Succesfully Submitted"),
            // content: new Text("Total Billing: " '$total'),
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
            title: new Text("Error Connection."),
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
