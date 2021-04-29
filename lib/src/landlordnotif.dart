import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:payrent/src/addbill.dart';
import 'package:payrent/src/delete.dart';
import 'package:payrent/src/tenant_history.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class landlordnotif extends StatefulWidget {
  landlordnotifState createState() => landlordnotifState();

  bool loading = false;
}

// ignore: camel_case_types
class landlordnotifState extends State<landlordnotif> {
  List data = [];
  String userid;

  Future<List> getData() async {
    var urls = Uri.parse("https://payrent000.000webhostapp.com/getallsetonlandlord.php");
    final response = await http.post(urls, body: {});
    return data = json.decode(response.body);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text("Notification"),
          centerTitle: true,
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
          child: FutureBuilder<List>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? new ItemList(
                      list: snapshot.data,
                    )
                  : new Container(
                      color: Colors.green[200],
                      child: Center(
                        child: SpinKitWave(
                          color: Colors.green[600],
                        ),
                      ));
            },
          ),
        ));
  }
}

class ItemList extends StatelessWidget {
  final List list;

  String value;
  ItemList({this.list, this.value});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        String numb = '${list[i]['contact_number']}';

        Future<String> usr() async {
            Container(
                              child: Center(
                              child: SpinKitWave(
                                color: Colors.green[600],
                              ),
                            ));
                                
                                
          var we = Uri.parse("https://payrent000.000webhostapp.com/setofflandlord.php");
          final respnse =
              await http.post(we, body: {"username": '${list[i]['username']}'});
          var myInt = int.parse(respnse.body);
         

          if (myInt == 2) {
            String smstenant = 'sms:$numb?body=text%20message';
            launch(smstenant);
          }
        }

        return new Container(
          child: Card(
              color: Colors.green[50],
              child: Column(
                children: [
                  Center(
                      child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" ${list[i]['username']} "),
                        Text(" ${list[i]['contact_number']}"),
                      ],
                    ),
                  )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new RaisedButton.icon(
                                icon: FaIcon(FontAwesomeIcons.sms),
                                label: new Text("READ"),
                                color: Colors.green[200],
                                onPressed:
                                
                                
                                 usr),
                          ],
                        ), 
                      ]))
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              
              ),

              
        );
        
      },
    );
  }
}
