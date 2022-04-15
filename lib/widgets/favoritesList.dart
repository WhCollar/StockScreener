import 'package:flutter/material.dart';
import 'package:coffee/widgets/qouteWidget.dart';
import 'package:coffee/database/database.dart';
import 'package:coffee/models/ticker.dart';


class FavoritesList extends StatefulWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  FavoritesListState createState() => FavoritesListState();
}

class FavoritesListState extends State<FavoritesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: FutureBuilder(
        future: DBProvider.db.getFavoriteTicker(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, int index) {
                Ticker item = snapshot.data![index];
                return ListTile(
                  title: Text(item.title, style: const TextStyle(fontSize: 25)),
                  trailing: Quote(item.title),
                  leading: Checkbox(
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
