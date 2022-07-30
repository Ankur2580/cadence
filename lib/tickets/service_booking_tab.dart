import 'package:Cadence/leftmenu/login_drawer.dart';
import 'package:Cadence/tickets/service_booking.dart';
import 'package:Cadence/tickets/service_ticket.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../styles.dart';

class ServiceBookingTab extends StatefulWidget {
  @override
  _ServiceBookingTabState createState() => _ServiceBookingTabState();
}

class _ServiceBookingTabState extends State<ServiceBookingTab> {
  final List<Map<String, Object>> _pages = [
    {
      'page': ServiceTicket(),
      'title': 'Service Tickets',
    },
    {
      'page': ServiceBooking(),
      'title': 'New Service Request',
    },
  ];

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        backgroundColor: HexColor("0EA923"),
      ),
      backgroundColor: Styles.appBgColor,
      drawer: LoginDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.green[900],
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.local_activity),
            title: Text("Service Tickets"),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.miscellaneous_services),
            title: Text('New Service Request'),
          ),
        ],
      ),
    );
  }
}
