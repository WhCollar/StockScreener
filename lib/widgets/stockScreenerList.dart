import 'package:flutter/material.dart';
import 'package:coffee/widgets/qouteWidget.dart';
import 'package:coffee/database/database.dart';
import 'package:coffee/database/models/ticker.dart';
import 'package:coffee/widgets/navigationDrawerWidget.dart';

class StockScreenerList extends StatefulWidget {
  const StockScreenerList({Key? key}) : super(key: key);

  @override
  StockScreenerListState createState() => StockScreenerListState();
}

class StockScreenerListState extends State<StockScreenerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(title: const Text("Markets")),
      body: FutureBuilder<List<Ticker>>(
        future: DBProvider.db.getAllTicker(),
        builder: (BuildContext context, AsyncSnapshot<List<Ticker>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, int index) {
                Ticker item = snapshot.data![index];
                return ListTile(
                  title: Text(item.title, style: const TextStyle(fontSize: 25)),
                  leading: Quote(item.title),
                  trailing: Checkbox(
                    onChanged: (value) {
                      DBProvider.db.addOrRemoveFromFavorites(item);
                      setState(() {});
                    },
                    value: item.favorite,
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

