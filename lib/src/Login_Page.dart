import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/loading/loadingPage.dart';
import 'package:payrent/src/landloardhome.dart';
import 'Home_Page.dart';

// ignore: camel_case_types
class loginPage extends StatefulWidget {
  static String tag = 'loginPage';
  _loginPageState createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {
  // String id;
  // final db = Firestore.instance;
  String value;
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool loading = false;

  String status;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return loading
        ? loadingPage()
        : Scaffold(
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
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(),
                          child: Image.asset('img/assets/logo.png'),
                        ),
                        new Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 80.0, right: 80.0, top: 0.0),
                                child: new Container(
                                  alignment: Alignment.center,
                                  height: 70.0,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Username Name Required.!';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Username',
                                      labelStyle: textStyle,
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
                                    left: 80.0, right: 80.0, top: 10.0),
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
                                        if (_formKey.currentState.validate()) {
                                          login();
                                          setState(
                                            () => loading = true,
                                          );
                                        }
                                      },
                                      minWidth: 40.0,
                                      height: 30.0,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
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
            ),
          );
  }

  void login() async {
    var url = Uri.parse("https://payrent000.000webhostapp.com/login.php");
    //var url = Uri.parse("http://192.168.1.32/payrent/login.php");
    var result = await http.post(url, body: {
      "password": password.text,
      "username": username.text,
    });

    var myInt = int.parse(result.body);
    print(myInt);

    if (myInt == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => tenanthomepages(
                  value: username.text, valuepa: password.text)));
    } else if (myInt == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => landlordhomepages()));
    } else if (myInt == 5) {
      setState(
        () => loading = false,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Username Exist!"),
            content: new Text("Account Not Verify"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new loginPage()));
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(
        () => loading = false,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            // title: new Text("Username Exist!"),
            content: new Text("Invalid Account"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new loginPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }
}
