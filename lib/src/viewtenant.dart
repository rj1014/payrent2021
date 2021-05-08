import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/Login_Page.dart';
import 'package:payrent/src/landloardhome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'home_page.dart';

class ViewTenant extends StatefulWidget {
  final List list;
  final int index;

  ViewTenant({this.list, this.index});

  @override
  _ViewTenantState createState() => _ViewTenantState();
}

class _ViewTenantState extends State<ViewTenant> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController roomno = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController contactnum = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController dateoccupancy = TextEditingController();
  bool loading = true;

  @override
  initState() {
    roomno =
        new TextEditingController(text: widget.list[widget.index]['room_no']);
    // getTenantDetails();
    initializeData();
    super.initState();
  }

  Future getTenantDetails() async {
    var result = await http.post(
      Uri.parse("https://payrent000.000webhostapp.com/get-tenant-details.php"),
      body: {
        "roomid": '${widget.list[widget.index]['roomid']}',
      },
    );
    dateoccupancy..text = jsonDecode(result.body)['date_occupancy'];
    firstname..text = jsonDecode(result.body)['fname'];
    lastname..text = jsonDecode(result.body)['lname'];
    username..text = jsonDecode(result.body)['username'];
    contactnum..text = jsonDecode(result.body)['contact_number'];
    password..text = jsonDecode(result.body)['password'];
  }

  initializeData() async {
    await getTenantDetails();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView(
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
                                      onTap: () {},
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Date Occupamncy",
                                        labelStyle: textStyle,
                                        icon: FaIcon(
                                          FontAwesomeIcons.calendarAlt,
                                          color: Colors.white,
                                        ),
                                      ),
                                      controller: dateoccupancy,
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
                                      controller: contactnum,
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
                        ],
                      ),
                    ),
                  ),
                )),
          );
  }
}

// class ViewTenant extends StatefulWidget {
//   final List list;
//   final int index;
//   String value;

//   ViewTenant({this.list, this.index, this.value});

//   @override
//   _ladlordaddState createState() => new _ladlordaddState(value);
// }

// class _ladlordaddState extends State<ViewTenant> {
//   String id;
//   String value;
//   List data = [];
//   bool loading = false;
//   DateTime _date = new DateTime.now();
//   DateTime _datetext = DateTime.now();
//   Future<List> getData() async {
//     var urls = Uri.parse("https://payrent000.000webhostapp.com/getroom.php");
//     final response = await http.post(urls, body: {"room_no": value});
//     return data = json.decode(response.body);
//   }

//   final _formKey = GlobalKey<FormState>();
//   TextEditingController room_no = TextEditingController();
//   TextEditingController firstname = TextEditingController();
//   TextEditingController lastname = TextEditingController();
//   TextEditingController username = TextEditingController();
//   TextEditingController contactnum = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController date_occupancy = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DateFormat df = DateFormat("dd/MM/yyyy");
//     TextStyle textStyle = Theme.of(context).textTheme.title;
//     return loading
//         ? loadingPage()
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.green[200],
//               title: Text('Pad Number ${widget.list[widget.index]['room_no']}'),
//               centerTitle: true,
//             ),
//             drawer: Drawer(
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: <Widget>[
//                   UserAccountsDrawerHeader(
//                     decoration: BoxDecoration(
//                       color: Colors.green[200],
//                     ),
//                     accountName: Text(""),
//                     accountEmail: Text("Username: Landlord"),
//                     currentAccountPicture: CircleAvatar(
//                       backgroundColor:
//                           Theme.of(context).platform == TargetPlatform.iOS
//                               ? Colors.green[200]
//                               : Colors.white,
//                       child: Text(
//                         "P",
//                         style: TextStyle(fontSize: 40.0),
//                       ),
//                     ),
//                   ),
//                   ListTile(
//                     leading: FaIcon(FontAwesomeIcons.home),
//                     title: Text('Home Page'),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => new landlordhomepages()));
//                     },
//                   ),
//                   ListTile(
//                     leading: FaIcon(FontAwesomeIcons.powerOff),
//                     title: Text('Logout'),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => new loginPage()));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             backgroundColor: Colors.grey[600],
//             body: Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("img/assets/bg.jpeg"),
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                         Colors.grey.withOpacity(0.3), BlendMode.dstATop),
//                   ),
//                 ),
//                 child: Center(
//                   child: Form(
//                     key: _formKey,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 40.0,
//                                     child: TextFormField(
//                                       onTap: () {},
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           date_occupancy.text =
//                                               _datetext.toString();
//                                         }
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: "Date Occupamncy",
//                                         labelStyle: textStyle,
//                                         icon: FaIcon(
//                                           FontAwesomeIcons.calendarAlt,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       controller: date_occupancy,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 70.0,
//                                     child: TextFormField(
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           return 'Please enter your first name';
//                                         }
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'First Name',
//                                         labelStyle: textStyle,
//                                         icon: Icon(Icons.person,
//                                             color: Colors.green[600]),
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 25),
//                                       controller: firstname,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 70.0,
//                                     child: TextFormField(
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           return 'Please enter your last name';
//                                         }
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Last Name',
//                                         labelStyle: textStyle,
//                                         icon: Icon(Icons.person,
//                                             color: Colors.green[600]),
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 25),
//                                       controller: lastname,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 70.0,
//                                     child: TextFormField(
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           return 'Enter your UserName';
//                                         }
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'UserName',
//                                         labelStyle: textStyle,
//                                         icon: Icon(Icons.supervised_user_circle,
//                                             color: Colors.blue),
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 25),
//                                       controller: username,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 70.0,
//                                     child: TextFormField(
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           return 'Enter your Contact Number';
//                                         }
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Contact Number',
//                                         labelStyle: textStyle,
//                                         icon: Icon(Icons.phone,
//                                             color: Colors.pink),
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 25),
//                                       controller: contactnum,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           new Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 50.0, right: 50.0, top: 10.0),
//                                   child: new Container(
//                                     alignment: Alignment.center,
//                                     height: 70.0,
//                                     child: TextFormField(
//                                       validator: (value) {
//                                         if (value.length < 8) {
//                                           if (value.isEmpty) {
//                                             return 'Password is empty';
//                                           } else {
//                                             return 'Atleast 8 character';
//                                           }
//                                         }

//                                         return null;
//                                       },
//                                       obscureText: true,
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         labelText: 'Password',
//                                         labelStyle: textStyle,
//                                         icon: Icon(Icons.vpn_key,
//                                             color: Colors.red),
//                                       ),
//                                       cursorColor: Colors.blueAccent,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 25),
//                                       controller: password,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )),
//           );
//   }
// }
