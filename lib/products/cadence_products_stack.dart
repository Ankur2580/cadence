import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/cadence_product_list.dart';

class CadenceProducts extends StatefulWidget {
  @override
  _CadenceProductsState createState() => _CadenceProductsState();
}

class _CadenceProductsState extends State<CadenceProducts> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBgColor,
      body: StackedCardCarousel(
        pageController: pageController,
        initialOffset: 10,
        spaceBetweenItems: 400,
        items: CadenceProductList.styleCards,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openwhatsapp();
        },
        child: const Icon(Icons.chat_sharp),
        backgroundColor: Colors.amber,
      ),
    );
  }

  //Send WhatsApp message
  Future<void> openwhatsapp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WidgetsFlutterBinding.ensureInitialized();
    var myName = prefs.getString('name');

    var whatsapp = "+919697983939";
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=My Name is " +
        myName +
        ", I am interested in Cadence bicycle.";
    var whatappURL_ios =
        "https://wa.me/$whatsapp?text=${Uri.parse("My Name is " + myName + ", I am interested in Cadence bicycle.")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }
}
