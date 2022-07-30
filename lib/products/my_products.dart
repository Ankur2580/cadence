import 'dart:convert';

import 'package:Cadence/auth/signup.dart';
import 'package:Cadence/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class MyProduct {
  final String name;
  final String description;
  final String make;
  final String phone;
  MyProduct(this.name, this.description, this.make, this.phone);
}

class _MyProductsState extends State<MyProducts> {
  List<MyProduct> productList = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var header = {'Content-type': 'application/json'};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    var myPhone = prefs.getString('phone');
    var url =
        Endpoint.uri('/api/product/list', queryParameters: {"phone": myPhone});

    // Map<String, Object> queryParams = {
    //   'phone': myPhone,
    // };
    // String queryString = Uri(queryParameters: queryParams).query;
    // var requestUrl = Uri.parse(url + '?' + queryString);
    var response = await http.get(url, headers: header);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var jsonBody = json.decode(responseBody);

      for (var data in jsonBody) {
        productList.add(
          new MyProduct(
            data['name'],
            data['description'],
            data['make'],
            data['phone'],
          ),
        );
      }
      setState(() {});
      productList.forEach((someData) => {print(someData.name)});
    } else if (response.statusCode == 500) {
      Center(
        child: Text('No products available'),
      );
    } else {
      Center(
        child: Text('No products added'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (_, index) {
        return new Container(
          margin: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: new Card(
            color: Colors.green[100],
            elevation: 10.0,
            child: Row(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('asset/images/ride.jpg'),
                      )),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                        '${productList[index].name}',
                        style: TextStyle(fontSize: 18),
                      ),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                        '${productList[index].description}',
                        style: TextStyle(fontSize: 12),
                      ),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                      new Text(
                        'Service Date : Please Schedule',
                        style: TextStyle(fontSize: 10),
                      ),
                      new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 3.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
