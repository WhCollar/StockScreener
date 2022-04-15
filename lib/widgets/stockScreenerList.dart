import 'package:flutter/material.dart';
import 'package:coffee/widgets/qouteWidget.dart';
import 'package:coffee/database/database.dart';
import 'package:coffee/models/ticker.dart';
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
      appBar: AppBar(
        title: const Text("Markets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: TickerItemsSearch());
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: DBProvider.db.getAllTicker(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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

class TickerItemsSearch extends SearchDelegate<Ticker?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Text("Результатов не найдено");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query.isEmpty
          ? DBProvider.db.getAllTicker()
          : DBProvider.db.searchTicker(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, int index) {
              Ticker item = snapshot.data![index];
              return ListTile(
                title: Text(item.title, style: const TextStyle(fontSize: 25)),
                leading: Quote(item.title),
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
    );
  }
}
