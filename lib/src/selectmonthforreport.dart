import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:intl/intl.dart';

class MonthReports extends StatefulWidget {
  @override
  _MonthReportsState createState() => new _MonthReportsState();
}

class _MonthReportsState extends State<MonthReports> {
  String value;
  bool loading = false;
  TextEditingController month = TextEditingController();

  double paid = 0.0;
  double unpaid = 0.0;
  double totalrevenue = 0.0;

  @override
  initState() {
    super.initState();
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
                        height: MediaQuery.of(context).size.height * 0.30,
                        // color: Colors.black,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            Container(
                              child: Text(
                                "Enter Billing Month",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005,
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
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Month",
                                          labelStyle: textStyle,
                                          icon: FaIcon(
                                            FontAwesomeIcons.calendarAlt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        controller: month,
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

                                if (month.text != "") {
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

  Future getAllBillsAmount() async {
    var url = Uri.parse(
        "https://payrent000.000webhostapp.com/get-all-bills-amount-2.php");
    var result = await http.post(
      url,
      body: {
        "month": month.text.toString(),
      },
    );

    print("result ${result.body}");

    setState(() {
      if (jsonDecode(result.body)[0] != null) {
        paid = double.parse(jsonDecode(result.body)[0]);
        totalrevenue = double.parse(jsonDecode(result.body)[0]);
      } else {
        paid = 0.0;
        totalrevenue = 0.0;
      }
      if (jsonDecode(result.body)[1] != null) {
        unpaid = double.parse(jsonDecode(result.body)[1]);
      } else {
        unpaid = 0.0;
      }
    });
  }
}
