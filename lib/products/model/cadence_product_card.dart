import 'package:flutter/material.dart';

class StyleCard extends StatelessWidget {
  final Image image;
  final String title;
  final String description;
  final String price;

  const StyleCard(
      {Key key, this.image, this.title, this.description, this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      child: ColoredBox(
        color: Colors.amber,
        child: Card(
          elevation: 7.0,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.65,
                  child: image,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.black87, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  price,
                  style: TextStyle(color: Colors.amber, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
