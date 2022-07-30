import 'dart:convert';

import 'package:Cadence/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'otp.dart';

class SignUp extends StatefulWidget {
  //static var baseUrl = 'http://192.168.10.100:5476/cadence-services';
  static var baseUrl = 'http://192.168.0.101:5476/cadence-services';
  // static var baseUrl = 'http://app.cadencemspl.com/cadence-service';

  static final fieldContact = TextEditingController();
  static final fieldName = TextEditingController();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //final fieldContact = TextEditingController();
  // final fieldEmail = TextEditingController();
  Future<void> register() async {
    var url = (Endpoint.uri('/api/user/signup'));
    // var url = Uri.parse(SignUp.baseUrl + '/api/user/signup');
    final headers = {'Content-type': 'application/json'};
    final data = jsonEncode({
      'name': SignUp.fieldName.text,
      'phone': SignUp.fieldContact.text,
    });
    final response = await http.post(url, headers: headers, body: data);

    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 406) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please check your Phone for OTP.'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Otp(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mobile number is already registered. Please try another phone number.',
          ),
        ),
      );
    }
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
          key: _formKey,
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                TextFormField(
                  validator: (fieldName) {
                    if (fieldName == null || fieldName.isEmpty) {
                      return "Please Enter Name";
                    }
                    return null;
                  },
                  controller: SignUp.fieldName,
                  decoration: InputDecoration(
                    hintText: 'Your Name',
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
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (fieldContact) {
                    if (fieldContact == null || fieldContact.isEmpty) {
                      return "Please Enter Mobile Number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: SignUp.fieldContact,
                  decoration: InputDecoration(
                    hintText: 'Mobile Number',
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
                SizedBox(height: 24.0),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      register();
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(12),
                  color: Colors.green,
                  child: Text('Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ]),
        ),
      ),
    );
  }
}
