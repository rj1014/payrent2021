import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
// import 'home_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/landloardviewaccount.dart';

class Editbilling extends StatefulWidget {
  final List list;
  final int index;
  String value;

  Editbilling({this.list, this.index, this.value});

  @override
  _EditbillingState createState() => new _EditbillingState(this.value);
}

class _EditbillingState extends State<Editbilling> {
  //date and time
  String value;

  _EditbillingState(this.value);

  bool loading = false;
  DateTime _date = new DateTime.now();
  DateTime _datetext = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  TextEditingController rentfee = TextEditingController();
  TextEditingController waterbill = TextEditingController();
  TextEditingController electricbill = TextEditingController();
  TextEditingController duedate = TextEditingController();
  TextEditingController status = TextEditingController();

  @override
  void initState() {
    rentfee =
        new TextEditingController(text: widget.list[widget.index]['rentfee']);
    waterbill =
        new TextEditingController(text: widget.list[widget.index]['waterbill']);
    electricbill = new TextEditingController(
        text: widget.list[widget.index]['electricbill']);
    duedate =
        new TextEditingController(text: widget.list[widget.index]['duedate']);
    status =
        new TextEditingController(text: widget.list[widget.index]['status']);
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
              title: Text('EDIT BILLING DATA'),
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
                          new Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80.0, right: 80.0, top: 10.0),
                                  child: new Container(
                                    alignment: Alignment.center,
                                    height: 70.0,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Amount Required.!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Status',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.shieldAlt,
                                            color: Colors.redAccent),
                                      ),
                                      controller: status,
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
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Date Required.!';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "DueDate",
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
                                      // keyboardType: TextInputType.number,
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
                                        labelText: 'RENT FEE',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.houseUser,
                                            color: Colors.blueGrey),
                                      ),
                                      controller: rentfee,
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
                                        labelText: 'Water Bill',
                                        labelStyle: textStyle,
                                        icon: FaIcon(
                                            FontAwesomeIcons.handHoldingWater,
                                            color: Colors.blueAccent),
                                      ),
                                      controller: waterbill,
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
                                        labelText: 'Electric Bill',
                                        labelStyle: textStyle,
                                        icon: FaIcon(FontAwesomeIcons.bolt,
                                            color: Colors.yellow),
                                      ),
                                      controller: electricbill,
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
                                            editbilling();
                                            setState(
                                              () => loading = true,
                                            );
                                          }
                                        },
                                        minWidth: 40.0,
                                        height: 30.0,
                                        child: Text(
                                          'Save',
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

  void editbilling() async {
    int total = int.parse(rentfee.text) +
        int.parse(waterbill.text) +
        int.parse(electricbill.text);
    var url = Uri.parse("https://payrent000.000webhostapp.com/editbill.php");
    var result = await http.post(url, body: {
      "billid": '${widget.list[widget.index]['billid']}',
      "duedate": duedate.text,
      "waterbill": waterbill.text,
      "electricbill": electricbill.text,
      "rentfee": rentfee.text,
      "total": '$total',
      "status": status.text,
    });
    print(total);
    var myInt = int.parse(result.body);
    print(myInt);
    if (myInt == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Succesfully Submited"),
            content: new Text("Total Billing: " '$total'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new ladlordviewacc()));
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
                },
              ),
            ],
          );
        },
      );
    }
  }
}
