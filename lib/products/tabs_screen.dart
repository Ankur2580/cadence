import 'package:Cadence/leftmenu/login_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'cadence_products_stack.dart';
import 'my_products.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': CadenceProducts(),
      'title': 'Cadence Bicycles',
    },
    {
      'page': MyProducts(),
      'title': 'My Bicycles',
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
            icon: Icon(Icons.pedal_bike),
            title: Text('Cadence Bicycles'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.directions_bike),
            title: Text("My Bicycles"),
          )
        ],
      ),
    );
  }
}
