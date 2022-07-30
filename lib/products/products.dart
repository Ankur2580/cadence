import 'dart:convert';

import 'package:Cadence/endpoint.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class Product {
  final String name;
  final String description;
  final String make;

  Product(
    this.name,
    this.description,
    this.make,
  );
}

class _ProductsState extends State<Products> {
  List<Product> productList = [];
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
    var url = Endpoint.uri('/api/product/cadence-list',
        queryParameters: {"phone": myPhone});

    // Map<String, Object> queryParams = {
    //   'phone': myPhone,
    // };
    //String queryString = Uri(queryParameters: queryParams).query;
    //var requestUrl = Uri.parse(url + '?' + queryString);
    var response = await http.get(url, headers: header);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String responseBody = response.body;
      var jsonBody = json.decode(responseBody);

      for (var data in jsonBody) {
        productList.add(
          new Product(
            data['name'],
            data['description'],
            data['make'],
          ),
        );
      }
      setState(() {});
      productList.forEach((someData) => {print(someData.name)});
    } else if (response.statusCode == 500) {
      Center(
        child: Text('No Bicycle available'),
      );
    } else {
      Center(
        child: Text('No Bicycle added'),
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
            color: Colors.teal[50],
            elevation: 10.0,
            child: Column(
              children: <Widget>[
                new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
                new Text(
                  '${productList[index].name}',
                  style: TextStyle(fontSize: 18),
                ),
                new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
                Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                        'https://www.cadencemspl.com/wp-content/uploads/2020/02/CadenceMobility-12-scaled.jpg'),
                    //fit: BoxFit.cover,
                  )),
                ),
                new Padding(
                  padding: new EdgeInsets.symmetric(vertical: 3.0),
                ),
                new Text(
                  '${productList[index].description}',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
