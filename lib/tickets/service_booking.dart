import 'dart:convert';

import 'package:Cadence/endpoint.dart';
import 'package:Cadence/news/news.dart';
import 'package:Cadence/tickets/service_booking_tab.dart';
import 'package:Cadence/tickets/service_ticket.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';

class ServiceBooking extends StatefulWidget {
  @override
  _ServiceBookingState createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String chosenTime;
  DateTime _selectedDate;

  TextEditingController _datetime = TextEditingController();
  final commentController = TextEditingController();

  Future<void> createServiceTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    var myPhone = prefs.getString('phone');

    var url = Endpoint.uri('/api/ticket/create');
    final header = {'Content-type': 'application/json'};

    print('requestDate: ${_datetime.text}');
    print('comment: ${commentController.text}');
    print('chosenTime: $chosenTime');
    print('phone: $myPhone');

    if (_datetime.text != null &&
        _datetime.text.length > 0 &&
        chosenTime != null) {
      final data = jsonEncode({
        'requestDate': _datetime.text,
        'comment': commentController.text,
        'message': chosenTime,
        'phone': myPhone,
      });

      var response = await http.post(url, headers: header, body: data);
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ServiceBookingTab()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your request for servicing has been sent'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide service date and time slot'),
        ),
      );
    }
  }

  final appBar = AppBar(
    backgroundColor: HexColor("0EA923"),
    title: Text(
      "Service Booking",
      style: TextStyle(fontSize: 20),
    ),
  );

  //Logo Object
  final service_image = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 58.0,
      child: Image.asset('asset/images/bicycle-service.png'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar,
      backgroundColor: Styles.appBgColor,
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  SizedBox(height: 15.0),

                  service_image,
                  SizedBox(height: 15.0),

                  //Service Date
                  TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _datetime,
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      hintText: 'Service Date',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.0),

                  //Time Slot
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    value: chosenTime,
                    isExpanded: true,
                    items: <String>[
                      '09:00AM - 12:00PM ( Morning )',
                      '01:00PM - 04:00PM ( Afternoon )',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Time Slot",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        chosenTime = value;
                      });
                    },
                  ),

                  SizedBox(height: 15.0),

                  //City
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: 'City',
                  //     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(32.0)),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide:
                  //           const BorderSide(color: Colors.green, width: 2.0),
                  //       borderRadius: BorderRadius.circular(25.0),
                  //     ),
                  //   ),
                  // ),

                  // SizedBox(height: 15.0),

                  // //Address
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: 'Adress',
                  //     contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(32.0)),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide:
                  //           const BorderSide(color: Colors.green, width: 2.0),
                  //       borderRadius: BorderRadius.circular(25.0),
                  //     ),
                  //   ),
                  // ),

                  //Comments
                  TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Comments (if Any)',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.0),

                  RaisedButton(
                    onPressed: () {
                      createServiceTicket();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: Colors.green[300],
                    child: Text(
                      'Confirm Booking',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null
            ? _selectedDate
            : (DateTime.now()).add(const Duration(days: 2)),
        firstDate: (DateTime.now()).add(const Duration(days: 2)),
        lastDate: (DateTime.now()).add(const Duration(days: 17)),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: HexColor("0EA923"),
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _datetime
        ..text = DateFormat('yyyy-MM-dd').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _datetime.text.length, affinity: TextAffinity.upstream));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
