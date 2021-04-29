import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'start_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payrent/src/Home_Page.dart';
// import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
// import 'package:intl/intl.dart';
import 'dart:convert';
import '../model.dart';

class uploadrec extends StatefulWidget {


  uploadrecState createState() => uploadrecState(billid,value,valuepa,amount);
  String s;
  String value;

  String valuepa;
  String billid;
  String amount;
  uploadrec({this.billid,this.value,this.valuepa,this.amount});

  String userid;
}

class uploadrecState extends State<uploadrec> {
  
  String userid;
  String valuepa;
  String value;
  String billid;
  String amount;

  uploadrecState(this.billid, this.value,this.valuepa, this.amount);

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        chooseImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      chooseImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Final picker = ImagePicker();
  String s;


  final _formKey = GlobalKey<FormState>();
  TextEditingController productname = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageCamera() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);

      return;
    }
    String fileName = tmpFile.path.split('/').last;
    
    if (upload(fileName) == null) {
      upload(fileName);
      // Future.delayed(Duration(milliseconds: 300), () {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => homepages(value: value)));
      // });
    }
    // print(upload(fileName));
  }

  upload(String fileName) async {
    
    var uploadEndPoint =
        Uri.parse("https://payrent000.000webhostapp.com/uploadre.php");
    var xname = ( billid+".jpg");
    var result = await http.post(uploadEndPoint, body: {
      "image": base64Image,
      "userid": userid,
      "username": value,
      "billid": billid,
      "amount": amount,
      "path":xname,
      
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => tenanthomepages(value: value,valuepa: valuepa,)));
    }).catchError((error) {
      // setStatus(error);
    });
    // print(result(re.body));
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Row(children: <Widget>[
              Expanded(
                child: Image.file(
                  snapshot.data,
                  // height: 200,
                  // fit: BoxFit.scaleDown,
                ),
              )
            ]),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Flexible(
              child: Row(children: <Widget>[
            Expanded(
              child: Text(
                'No Image Selected',
                textAlign: TextAlign.center,
              ),
            )
          ]));
        }
      },
    );
  }

  Future<String> usr() async {
    var we = Uri.parse("https://payrent000.000webhostapp.com/getinfo.php");
    final respnse = await http.post(we, body: {"username": value});
    return respnse.body;
  }

  Future getinfo() async {
    String jsonString = await usr();
    final res = json.decode(jsonString);
    this.setState(() {
      Userlogin userlogin = new Userlogin.fromJson(res[0]);
      userid = '${userlogin.userid}';
    });
  }

  @override
  initState() {
    super.initState();
    getinfo();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Receipt'),
        backgroundColor: Colors.green[200],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body:SingleChildScrollView( 
      child:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/assets/bg2.jpeg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
      child:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                
                
                height: MediaQuery.of(context).size.height / 2.1,
                child:Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  
                showImage(),
              ]),),),
              new Row(children: <Widget>[
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0),
                  child: Container(
                    child: RaisedButton.icon(
                      onPressed: () {
                        _showPicker(context); // call choose image function
                      },
                      icon: Icon(Icons.folder_open),
                      label: Text("CHOOSE IMAGE"),
                      color: Colors.green[200],
                      colorBrightness: Brightness.dark,
                    ),
                  ),
                ))
              ]),
             
              new Row(children: <Widget>[
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0),
                  child: Container(
                      //show upload button after choosing image
                      //if uploadimage is null then show empty container

                      //elese show uplaod button
                      child: RaisedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                                     startUpload();
                                    
                                    }
                      
                    },
                    //start uploading image

                    icon: Icon(Icons.file_upload),
                    label: Text("UPLOAD"),
                    color: Colors.green[200],
                    colorBrightness: Brightness.dark,
                    //set brghtness to dark, because deepOrangeAccent is darker coler
                    //so that its text color is light
                  )),
                ))
              ]),
              new Row(children: <Widget>[
                Expanded(
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ])
            ],
          ),
       ), ),),
      ),
    );
  }
}
