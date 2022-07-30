import 'dart:convert';

import 'package:Cadence/endpoint.dart';
import 'package:Cadence/leftmenu/login_drawer.dart';
import 'package:Cadence/auth/signup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import '../styles.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class NewsFields {
  final String title;
  final String subtitle;
  final String author;
  final String date;
  final String articleUrl;
  final String imagesURL;
  final String contentPreview;
  NewsFields(this.title, this.subtitle, this.author, this.date, this.articleUrl,
      this.imagesURL, this.contentPreview);
}

class _NewsState extends State<News> {
  final ScrollController _scrollController = ScrollController();

  int page = 0;
  final int pageSize = 5;
  var url = Endpoint.uri('/public/latest-news',
      queryParameters: {"page": "0", "pageSize": "5"});
  List<NewsFields> newsList = [];
  @override
  void initState() {
    // FirebaseMessaging.instance.requestPermission();
    // FirebaseMessaging.onMessage.map((msg) {
    //   print(msg);
    // });
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
    super.initState();
    loadNews();
  }

  loadNews() async {
    var header = {'Content-type': 'application/json'};
    // Map<String, Object> queryParams = {
    //   'page': page.toString(),
    //   'pageSize': pageSize.toString()
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
        newsList.add(
          new NewsFields(
            data['title'],
            data['subtitle'],
            data['author'],
            data['date'],
            data['articleUrl'],
            data['imagesURL'],
            data['contentPreview'],
          ),
        );
      }
      setState(() {});
      newsList.forEach(
        (someData) => {
          print(someData.title),
        },
      );
    } else if (response.statusCode == 500) {
      Center(
        child: Text('Something went wrong'),
      );
    }
  }

  final appBar = AppBar(
    backgroundColor: HexColor("0EA923"),
    centerTitle: false,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "EV World This Week ",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Powered by evbazzar.com',
          style: TextStyle(fontSize: 9),
        ),
      ],
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
      drawer: LoginDrawer(),
      appBar: appBar,
      backgroundColor: Styles.appBgColor,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          var metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            if (metrics.pixels == 0) {
              //print('At top');
            } else {
              this.page++;
              //print('At bottom, Current page : ${this.page}');
              loadNews();
            }
          }
          return true;
        },
        child: Container(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: newsList.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  //URL Redirect
                  launch(newsList[index].articleUrl);
                },
                child: new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                  child: new Card(
                    color: Colors.teal[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 8.0,
                    child: Column(children: [
                      //Title Row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: new Text(
                              '${newsList[index].title}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Styles.headerLarge(),
                            ),
                          ),
                        ],
                      ),
                      // News Details
                      Row(
                        children: <Widget>[
                          if (newsList[index].imagesURL != null)
                            Container(
                              padding: EdgeInsets.all(10),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [CircularProgressIndicator()]),
                                imageUrl: '${newsList[index].imagesURL}',
                                height: 100,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (newsList[index].imagesURL == null)
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 100,
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('asset/images/p-trans.png'),
                                  )),
                            ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10.0,
                                bottom: 10.0,
                                right: 10.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${newsList[index].date} | ${newsList[index].author}',
                                    style: Styles.excerptText,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10.0)),
                                  new Text(
                                    '${newsList[index].contentPreview}',
                                    style: Styles.excerptText,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
