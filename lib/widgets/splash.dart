import 'package:coffee/widgets/stockScreenerList.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:coffee/database/database.dart';
import 'package:coffee/database/models/ticker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    String url =
        "https://finnhub.io/api/v1/stock/symbol?exchange=US&mic=XNYS&securityType=Common%20Stock&token=c8umg02ad3ibdduembmg";
    http.get(url).then((response) async {
      var parsedListJson = jsonDecode(response.body);
      for (var el in parsedListJson) {
        String title = el["symbol"];
        Ticker t = Ticker(title: title);
        await DBProvider.db.newTicker(t);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => StockScreenerList()));
    }).catchError((error) {
      print(error);
    });
    return Scaffold(
        appBar: AppBar(title: const Text("Stock screener")),
        backgroundColor: Colors.blue,
        body: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Синхронизация данных\n',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.only(left: 10.0, bottom: 30),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ]),
        ));
  }
}
