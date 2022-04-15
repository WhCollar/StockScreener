import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Quote extends StatelessWidget{
  final String _ticker;

  const Quote(this._ticker, {Key? key}) : super(key: key);

  Future<String> getQuote() async{
    String url = 'https://finnhub.io/api/v1/quote?symbol=$_ticker&token=c8umg02ad3ibdduembmg';
    try {
      var request = await http.get(url);
      Map<dynamic,dynamic> parsedListJson = jsonDecode(request.body);
      return "${parsedListJson['c']}";
    } catch (error) {
      return "0.0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getQuote(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.hasData){
          return Text("${snapshot.data}");
        }
        else {
          return const Text("0.0");
        }
      },
    );
  }
}
