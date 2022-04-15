import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:coffee/api/api.dart';
import 'package:coffee/widgets/stockScreenerList.dart';
import "package:http/http.dart" as http;
import 'package:coffee/models/ticker.dart';
import 'package:coffee/database/database.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    String _allTickersXNAS =
        "https://finnhub.io/api/v1/stock/symbol?exchange=US&mic=XNAS&securityType=Common%20Stock&token=c8umg02ad3ibdduembmg";

    http.get(_allTickersXNAS).then((response) async {
      var parsedListJson = jsonDecode(response.body);
      for (var el in parsedListJson) {
        await DBProvider.db.newTicker(Ticker(title: el["symbol"]));
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const StockScreenerList()));
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
