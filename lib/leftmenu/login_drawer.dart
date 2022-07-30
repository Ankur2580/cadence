import 'package:Cadence/auth/signup.dart';
import 'package:Cadence/endpoint.dart';
import 'package:Cadence/products/tabs_screen.dart';
import 'package:Cadence/tickets/register_bicycle.dart';
import 'package:Cadence/tickets/service_booking_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:Cadence/news/news.dart';

class LoginDrawer extends StatefulWidget {
  @override
  _LoginDrawerState createState() => _LoginDrawerState();
}

class UserProfile {
  String name;
  String phone;

  UserProfile(
    this.name,
    this.phone,
  );
}

class Role {
  int id;
  String authority;
  Role(
    this.id,
    this.authority,
  );
}

class _LoginDrawerState extends State<LoginDrawer> {
  UserProfile userProfile = new UserProfile(
    '',
    '',
  );

  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      userProfile.name = prefs.getString('name');
      userProfile.phone = prefs.getString('phone');
    });

    //print(userProfile.name);
  }

  getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      userProfile.phone = prefs.getString('phone');
    });
    // var url = Endpoint.uri('/user/getRole',
    //     queryParameters: {"phone": userProfile.phone});
    var url = (SignUp.baseUrl + '/user/getRole');
    Map<String, Object> queryParams = {
      'phone': userProfile.phone,
    };
    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = Uri.parse(url + '?' + queryString);
    var header = {'Content-type': 'application/json'};
    var response = await http.get(
      requestUrl,
      headers: header,
    );
    // var response = await http.get(
    //   url,
    //   headers: header,
    // );
    print(response);
    if (response == 1) {
      return;
    } else if (response == 2) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Service Engineer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HexColor("0EA923"),
              ),
            ),
            leading: Icon(
              Icons.engineering,
              color: HexColor("0EA923"),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      );
    }
    if (response.statusCode == 200) {
      return;
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  // Future<String> getProfile(String name) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   WidgetsFlutterBinding.ensureInitialized();

  //   setState(() {
  //     this.name = preferences.getString('name');
  //     this.phone = preferences.getString('phone');

  //     print(phone);
  //     print(name);
  //     return Text(name);
  //   });
  //   return name;
  // }

  Future signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('name');
    preferences.remove('phone');
    Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));
  }
  //var phone = SignUp.fieldContact.text;
  // var url = Uri.parse(SignUp.baseUrl + '/api/user/username');
  // List<Username> username = [];

  // @override
  // void initState() {
  //   super.initState();
  //   loadData();
  // }

  // loadData() async {
  //   var response =
  //       await http.get(url, headers: {'Content-type': 'application/json'});
  //   if (response.statusCode == 200) {
  //     String responseBody = response.body;
  //     var jsonBody = json.decode(responseBody);
  //     for (var data in jsonBody) {
  //       username.add(
  //         new Username(
  //           data['name'],
  //         ),
  //       );
  //     }
  //     setState(() {});
  //     username.forEach((element) {
  //       print(element.name);
  //     });
  //   } else {
  //     print('Something is wrong');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    getUserProfile();

    //Logo Object
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 58.0,
        child: Image.asset('asset/images/cadence_logo.jpeg'),
      ),
    );

    return Drawer(
      child: Container(
        color: Colors.grey[350],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  logo,
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                        ),
                        Text(
                          'Welcome ' +
                              userProfile.name +
                              '  ' +
                              userProfile.phone +
                              ' ',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.green[900], fontSize: 15),
                        ),

                        // FutureBuilder(
                        //   builder:
                        //       (BuildContext, AsyncSnapshot<Widget> snapshot) {
                        //     if (snapshot.hasData) {
                        //       return Text('$getUserName');
                        //     } else {
                        //       return CircularProgressIndicator();
                        //     }
                        //     // return Text('${getUserName()}');
                        //   },

                        // ),
                        // ListTile(
                        //   title: FutureBuilder(
                        //     builder: (context, data) {
                        //       if (data.hasData) {
                        //         return Text(data.data);
                        //       } else
                        //         return Text('');
                        //     },
                        //     future: getProfile(),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<Widget>(
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return getUserRole();
                }
                return SizedBox();
              },
            ),

            ListTile(
              title: Text(
                'Register Bicycle',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor("0EA923"),
                ),
              ),
              leading: Icon(
                Icons.directions_bike,
                color: HexColor("0EA923"),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RegisterBicycle()));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'Doorstep Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor("0EA923"),
                ),
              ),
              leading: Icon(
                Icons.miscellaneous_services,
                color: HexColor("0EA923"),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ServiceBookingTab()));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor("0EA923"),
                ),
              ),
              leading: Icon(
                Icons.feed,
                color: HexColor("0EA923"),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => News()));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => TabsScreen()));
              },
              title: Text(
                'Products',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: HexColor("0EA923")),
              ),
              leading: Icon(
                Icons.pedal_bike,
                color: HexColor("0EA923"),
              ),
              //leading: Icon(Icons.book_rounded, color: Colors.grey[400]),
            ),
            Divider(
              color: Colors.black,
            ),
            // ListTile(
            //   title: Text(
            //     'Invoices',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.grey[400],
            //     ),
            //   ),
            //   leading: Icon(Icons.money, color: Colors.grey[400]),
            // ),
            // Divider(
            //   color: Colors.black,
            // ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: HexColor("0EA923"),
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: HexColor("0EA923"),
              ),
              onTap: () {
                signOut();
              },
            ),
            Divider(
              color: Colors.black,
            ),

            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                  ),
                  Text(
                    'Cadence Mobility Solutions Pvt Ltd',
                    style: TextStyle(
                      fontSize: 15,
                      color: HexColor("0EA923"),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 20),
                      ),
                      Container(
                        height: 25,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('asset/images/india.png'),
                          //fit: BoxFit.cover,
                        )),
                      ),
                      Text(
                        'Proudly made in India',
                        style: TextStyle(
                          fontSize: 12,
                          color: HexColor("0EA923"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 30),
                      ),
                      Text(
                        'Version 1.0.0 | www.cadencemspl.com ',
                        style: TextStyle(
                          fontSize: 12,
                          color: HexColor("0EA923"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
