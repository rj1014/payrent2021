import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:intl/intl.dart';

class DateReports extends StatefulWidget {
  @override
  _DateReportsState createState() => new _DateReportsState();
}

class _DateReportsState extends State<DateReports> {
  String value;
  bool loading = false;
  DateTime _date = new DateTime.now();
  DateTime _datetext = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  TextEditingController enddate = TextEditingController();
  TextEditingController startdate = TextEditingController();

  double paid = 0.0;
  double unpaid = 0.0;
  double totalrevenue = 0.0;

  @override
  initState() {
    super.initState();
  }

  Future<Null> _selectStartDate(BuildContext context) async {
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
        startdate.text = b.toString();
      });
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
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
        enddate.text = b.toString();
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.25,
                        // color: Colors.black,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Row(
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
                                          _selectStartDate(context);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            startdate.text =
                                                _datetext.toString();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Start Date",
                                          labelStyle: textStyle,
                                          icon: FaIcon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        controller: startdate,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
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
                                          _selectEndDate(context);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            enddate.text = _datetext.toString();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "End Date",
                                          labelStyle: textStyle,
                                          icon: FaIcon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        controller: enddate,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            MaterialButton(
                              onPressed: () async {
                                // print(startdate.text);
                                // print(enddate.text);

                                if (startdate.text != "" ||
                                    enddate.text != "") {
                                  await getAllBillsAmount();
                                }
                              },
                              color: Colors.green,
                              child: Text("Get Data"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Paid: $paid",
                            ),
                            Text("Unpaid: $unpaid"),
                            Text("Total Revenue: $totalrevenue"),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.05,
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 1,
                      //   height: MediaQuery.of(context).size.height * 0.70,
                      // )
                    ],
                  ),
                )),
          );
  }

  Future getAllBills() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/getAllBills.php");
    var result = await http.post(
      url,
      body: {
        "startdate": startdate.text,
        "enddate": enddate.text,
      },
    );
  }

  Future getAllBillsAmount() async {
    print(startdate.text);
    print(enddate.text);
    var url = Uri.parse(
        "https://payrent000.000webhostapp.com/get-all-bills-amount.php");
    var result = await http.post(
      url,
      body: {
        "startdate": startdate.text.toString(),
        "enddate": enddate.text.toString(),
      },
    );

    print("result ${result.body}");

    setState(() {
      if (jsonDecode(result.body)[0] != null) {
        paid = double.parse(jsonDecode(result.body)[0]);
        totalrevenue = double.parse(jsonDecode(result.body)[0]);
      } else {
        unpaid = 0.0;
        totalrevenue = 0.0;
      }
      if (jsonDecode(result.body)[1] != null) {
        unpaid = double.parse(jsonDecode(result.body)[1]);
      } else {
        paid = 0.0;
      }
    });
  }
}
