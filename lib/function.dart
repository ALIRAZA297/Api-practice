import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
    String text;
    String author;

    Welcome({
        required this.text,
        required this.author,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        text: json["text"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "author": author,
    };
}