class Userlogin {
  final String fname;
  final String lname;
  final String contact_number;
  final String username;
  final String userid;
  final String billid;
  final String password;
  final String totalamount;
  

  


  // ignore: non_constant_identifier_names
  Userlogin({this.fname, this.lname, this.contact_number, this.username, this.userid, this.billid, this.password, this.totalamount});

  factory Userlogin.fromJson(Map<String, dynamic> json) {
    return Userlogin(
        fname: json['fname'],
        lname: json['lname'],
        contact_number: json['contact_number'],
        username: json['username'],
        userid: json['userid'],
        billid: json['billid'],
        password: json['password'],
        totalamount: json['totalamount']
        );
  }

  Map<String, dynamic> toJson() =>
      {'fname': fname, 'lname': lname, 'contact_number': contact_number,'username': username, 'userid': userid,'billid': billid, 'password':password, 'totalamount':totalamount};
}
