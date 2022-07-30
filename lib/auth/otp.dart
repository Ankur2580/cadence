import 'dart:convert';

import 'package:Cadence/auth/signup.dart';
import 'package:Cadence/endpoint.dart';

import '../tickets/register_bicycle.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class UserProfile {
  final String name;
  final String phone;
  final int role;
  UserProfile(this.name, this.phone, this.role);
}

class _OtpState extends State<Otp> {
  bool agree = false;
  final fieldOtp = TextEditingController();
  //final fieldPhone = TextEditingController();

  Future<void> createAccount() async {
    var url = Endpoint.uri('/api/user/checkotp', queryParameters: {
      "phone": SignUp.fieldContact.text,
      "otp": fieldOtp.text
    });
    final headers = {
      'Content-type': 'application/json',
    };
    // Map<String, Object> queryParams = {
    //   'phone': SignUp.fieldContact.text,
    //   'otp': fieldOtp.text,
    // };
    // String queryString = Uri(queryParameters: queryParams).query;
    // var requestUrl = Uri.parse(url + '?' + queryString);
    List<UserProfile> userProfile = [];

    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      WidgetsFlutterBinding.ensureInitialized();

      prefs.setString('name', SignUp.fieldName.text);
      prefs.setString('phone', SignUp.fieldContact.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => RegisterBicycle()));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome to Cadence World!'),
        ),
      );
      String responseBody = response.body;
      var jsonBody = jsonDecode(responseBody);
      for (var data in jsonBody) {
        userProfile
            .add(new UserProfile(data['name'], data['phone'], data['role']));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wrong OTP'),
        ),
      );
    }
    Widget widget = ListView.builder(itemBuilder: (_, index) {
      return Row(
        children: <Widget>[
          new Text('${userProfile[index].name}'),
          new Text('${userProfile[index].phone}')
        ],
      );
    });

    //runApp(MaterialApp(home: fieldPhone == null ? Otp() : SignUp()));
  }

  //Logo Object
  final logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 58.0,
      child: Image.asset('asset/images/cadence_logo.jpeg'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              Text(
                "Please provide OTP shared on Phone",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 48.0),
              TextFormField(
                controller: fieldOtp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.green, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              Row(
                children: [
                  Material(
                    child: Checkbox(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value;
                        });
                      },
                    ),
                  ),
                  Text.rich(TextSpan(
                      text: "I agree with T&C Conditions ",
                      style: TextStyle(fontSize: 14),
                      children: <InlineSpan>[
                        TextSpan(
                            text: "click to view",
                            style: TextStyle(
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline))
                      ])),
                ],
              ),
              SizedBox(height: 48.0),
              RaisedButton(
                onPressed: agree ? createAccount : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.green,
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     drawer: DrawerPage(),
  //     body: SingleChildScrollView(
  //       child: Form(
  //         child: Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(top: 30.0),
  //               child: Center(
  //                 child: Container(
  //                     padding: EdgeInsets.only(bottom: 30.0),
  //                     width: 400,
  //                     height: 200,
  //                     child: Image.asset('asset/images/cadence_logo.jpeg')),
  //               ),
  //             ),
  //             Container(
  //               padding: EdgeInsets.all(15),
  //               child: Column(
  //                 children: <Widget>[
  //                   Container(
  //                     padding: EdgeInsets.only(left: 15),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "Please provide OTP shared on Phone",
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               color: Colors.green,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 15.0, right: 15.0, top: 25, bottom: 10),
  //                     child: TextFormField(
  //                       controller: fieldOtp,
  //                       keyboardType: TextInputType.number,
  //                       decoration: InputDecoration(
  //                         focusedBorder: UnderlineInputBorder(
  //                           borderSide: BorderSide(color: HexColor("0EA923")),
  //                         ),
  //                         isDense: true,
  //                         contentPadding: EdgeInsets.only(bottom: 8),
  //                         border: UnderlineInputBorder(),
  //                         hintText: 'OTP',
  //                         hintStyle: TextStyle(color: Colors.black),
  //                       ),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       Material(
  //                         child: Checkbox(
  //                           value: agree,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               agree = value;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                       Text.rich(TextSpan(
  //                           text: "I agree with T&C Conditions ",
  //                           style: TextStyle(fontSize: 14),
  //                           children: <InlineSpan>[
  //                             TextSpan(
  //                                 text: "click to view",
  //                                 style: TextStyle(
  //                                     color: Colors.blue[900],
  //                                     decoration: TextDecoration.underline))
  //                           ])),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.20,
  //             ),
  //             Container(
  //               height: 50,
  //               width: 300,
  //               decoration: BoxDecoration(
  //                 color: Colors.green,
  //                 //borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: FlatButton(
  //                 onPressed: agree ? createAccount : null,
  //                 color: HexColor("307B21"),
  //                 child: Text(
  //                   'Sign up',
  //                   style: TextStyle(color: Colors.white, fontSize: 20),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
