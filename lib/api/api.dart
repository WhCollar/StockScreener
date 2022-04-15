import 'dart:convert';
import 'package:coffee/widgets/stockScreenerList.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:coffee/models/ticker.dart';
import 'package:coffee/database/database.dart';


class FinHubAPI {

  FinHubAPI._();

  static final FinHubAPI api = FinHubAPI._();

  final String _allTickersXNAS =
      "https://finnhub.io/api/v1/stock/symbol?exchange=US&mic=XNAS&securityType=Common%20Stock&token=c8umg02ad3ibdduembmg";


  Future<bool> syncDatabaseWithExchangeXNAS(BuildContext context) async {
    http.get(_allTickersXNAS).then((response) async {
      var parsedListJson = jsonDecode(response.body);
      for (var el in parsedListJson) {
        await DBProvider.db.newTicker(Ticker(title: el["symbol"]));
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const StockScreenerList()));
    });
    return false;
  }

}
