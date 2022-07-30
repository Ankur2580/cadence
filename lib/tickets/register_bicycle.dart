import 'dart:convert';

import 'package:Cadence/auth/signup.dart';
import 'package:Cadence/endpoint.dart';
import 'package:Cadence/leftmenu/login_drawer.dart';
import 'package:http/http.dart' as http;

import '../styles.dart';
import 'service_booking.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

class RegisterBicycle extends StatefulWidget {
  @override
  _RegisterBicycleState createState() => _RegisterBicycleState();
}

class _RegisterBicycleState extends State<RegisterBicycle> {
  File imageFile;
  String _chosenValue;
  final modelName = TextEditingController();

  String radioButtonItem = 'Adult Bicycle';

  // Group Value for Radio Button.
  int id = 1;

  final appBar = AppBar(
    backgroundColor: HexColor("0EA923"),
    title: Text(
      "Register Bicycle",
      style: TextStyle(fontSize: 20),
    ),
  );
  Future<void> addProduct() async {
    var url = Endpoint.uri('/api/product/create');
    final header = {'Content-type': 'application/json'};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    var myPhone = prefs.getString('phone');

    print('Make: $_chosenValue');
    print('Model: ${modelName.text}');

    if (_chosenValue != null &&
        modelName.text != null &&
        modelName.text.length > 0) {
      final data = jsonEncode({
        'name': modelName.text,
        'description': radioButtonItem,
        'phone': myPhone,
        'make': _chosenValue,
      });
      final response = await http.post(url, headers: header, body: data);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ServiceBooking()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bicycle registered successfully'),
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
          content: Text('Please provide Bicycle Make and Model Name'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LoginDrawer(),
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: () {
          _showPicker(context);
        },
        backgroundColor: Colors.black45,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      backgroundColor: Styles.appBgColor,
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            if (imageFile == null)
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('asset/images/FHT11E.jpg'),
                )),
              )
            else
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
            SizedBox(height: 25.0),
            Container(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                children: [
                  Container(
                    child: DropdownButtonFormField<String>(
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
                      value: _chosenValue,
                      isExpanded: true,
                      isDense: true,
                      items: <String>[
                        'Cadence Mobility',
                        'Other Make',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Bicycle Make",
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: modelName,
                    decoration: InputDecoration(
                      hintText: 'Model name',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  //Adult Bicycle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.green,
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Adult Bicycle';
                            id = 1;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'Adult Bicycle',
                          style: new TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  //Kids Bicycle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Radio(
                        activeColor: Colors.green,
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Kids Bicycle';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Kids Bicycle',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 34.0),
                  RaisedButton(
                    onPressed: () {
                      addProduct();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.all(12),
                    color: Colors.green[300],
                    child: Text(
                      '             Register Bicycle             ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.04,
            // ),
            // Container(
            //   height: 50,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     color: Colors.green,
            //   ),
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.green[600]),
            //       textStyle: MaterialStateProperty.all(
            //         TextStyle(fontSize: 20),
            //       ),
            //     ),
            //     onPressed: () {
            //       addProduct();
            //     },
            //     // color: HexColor("307B21"),
            //     child: Text(
            //       'Register Bicycle',
            //       style: TextStyle(color: Colors.white, fontSize: 20),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future _imgFromCamera() async {
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    setState(() {
      imageFile = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      imageFile = File(image.path);
    });
  }

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
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
