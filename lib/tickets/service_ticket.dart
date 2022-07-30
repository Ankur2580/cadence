import 'dart:convert';

import 'package:Cadence/endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../styles.dart';

class ServiceTicket extends StatefulWidget {
  @override
  _ServiceTicketState createState() => _ServiceTicketState();
}

class Ticket {
  final String requestDate;
  final String createdOn;
  final int ticketState;
  final String message;
  final String comment;
  final int id;
  final Product product;

  Ticket(this.requestDate, this.createdOn, this.ticketState, this.message,
      this.comment, this.id, this.product);
}

class Product {
  final int id;
  final String name;
  final String description;
  final String make;
  Product(this.id, this.name, this.description, this.make);
}

class _ServiceTicketState extends State<ServiceTicket> {
  var myPhone;
  List<Ticket> ticketList = [];
  @override
  void initState() {
    super.initState();
    loadTicket();
  }

  loadTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    myPhone = prefs.getString('phone');
    var url = Endpoint.uri('/api/ticket/requested/list',
        queryParameters: {"phone": myPhone});

    var header = {'Content-type': 'applicaion/json'};

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
        var productJson = data['product'];

        Product p = new Product(
          productJson['id'],
          productJson['name'],
          productJson['description'],
          productJson['make'],
        );

        ticketList.add(
          new Ticket(
            data['requestDate'],
            data['createdOn'],
            data['ticketState'],
            data['message'],
            data['comment'],
            data['id'],
            p,
          ),
        );
      }
      setState(() {});
      ticketList.forEach((someData) => {print(someData.requestDate)});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ticketList.length > 0) {
      return ListView.builder(
        itemCount: ticketList.length,
        itemBuilder: (_, index) {
          return new Container(
            margin: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: new Card(
              color: Colors.teal[50],
              elevation: 10.0,
              child: Row(
                children: <Widget>[
                  // Container(
                  //   height: 100,
                  //   width: 120,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  //       image: DecorationImage(
                  //         fit: BoxFit.cover,
                  //         image: AssetImage('asset/images/ride.jpg'),
                  //       )),
                  // ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 3.0)),
                        new Text(
                          '${ticketList[index].requestDate} ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green[800],
                          ),
                        ),
                        new Text(
                          '${ticketList[index].message}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[800],
                          ),
                        ),
                        if (ticketList[index].ticketState == 1)
                          InputChip(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Very soon service engineer will contact you and update Ticket. '),
                                ),
                              );
                            },
                            onDeleted: () {},
                            avatar: const Icon(
                              Icons.directions_bike,
                              size: 20,
                              color: Colors.black54,
                            ),
                            deleteIconColor: Colors.black54,
                            label: Text('Open'),
                          ),
                        if (ticketList[index].ticketState == 2)
                          InputChip(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Very soon service engineer will contact you and update Ticket. '),
                                ),
                              );
                            },
                            onDeleted: () {},
                            avatar: const Icon(
                              Icons.directions_bike,
                              size: 20,
                              color: Colors.black54,
                            ),
                            deleteIconColor: Colors.black54,
                            label: Text('Scheduled Service'),
                          ),
                        if (ticketList[index].ticketState == 3)
                          InputChip(
                            backgroundColor: Colors.green,
                            avatar: const Icon(
                              Icons.directions_bike,
                              size: 20,
                              color: Colors.black54,
                            ),
                            deleteIconColor: Colors.black54,
                            label: Text('Closed'),
                          ),
                        if (ticketList[index].ticketState == 4)
                          InputChip(
                            avatar: const Icon(
                              Icons.directions_bike,
                              size: 20,
                              color: Colors.black54,
                            ),
                            deleteIconColor: Colors.black54,
                            label: Text('Canceled'),
                          ),
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 3.0)),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: new Text(
                            'Comment by you | ${ticketList[index].comment}',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 3.0)),
                        new Text(
                          '${ticketList[index].product.name} | ${ticketList[index].product.make} | ${ticketList[index].product.description} ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Scaffold(
        backgroundColor: Styles.appBgColor,
        body: Center(
          child: Column(
            children: [
              new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage('asset/images/Service.PNG'),
                      fit: BoxFit.cover,
                    )),
              ),
              new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
              Container(
                padding: EdgeInsets.all(20),
                height: 145,
                child: Center(
                  child: Text(
                    'Please feel free to create bicycle service Ticket.',
                    style: TextStyle(color: Colors.green[900], fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
