import 'dart:convert';

Ticker tickerFromMap(String str) => Ticker.fromMap(json.decode(str));

String tickerToMap(Ticker data) => json.encode(data.toMap());

class Ticker {
  int? id;
  String title;
  bool? favorite;

  Ticker({
    this.id,
    required this.title,
    this.favorite,
  });

  factory Ticker.fromMap(Map<String, dynamic> json) => Ticker(
    id: json["id"],
    title: json["title"],
    favorite: (json["favorite"] == 1)? true : false,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "favorite": (favorite!)? 1 : 0,
  };
}
