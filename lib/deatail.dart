import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'function.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late List<Welcome> welcome;
  Welcome? randomQuote;

  @override
  void initState() {
    super.initState();
    welcome = [];
    fetchRandomData();
  }

  Future<List<Welcome>> getData() async {
    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Welcome>.from(data.map((item) => Welcome.fromJson(item)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchRandomData() async {
    if (welcome.isEmpty) {
      try {
        welcome = await getData();
        fetchRandomQuote();
      } catch (error) {
        throw ('Error fetching data: $error');
      }
    } else {
      fetchRandomQuote();
    }
  }

  void fetchRandomQuote() {
    final random = Random();
    final randomIndex = random.nextInt(welcome.length);
    setState(() {
      randomQuote = welcome[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (randomQuote != null)
            Container(
              height: 200,
              width: double.infinity,
              color: const Color.fromRGBO(255, 255, 255, 0.541),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText('Text: ${randomQuote!.text}',
                          textStyle: const TextStyle(fontSize: 18),
                          speed: const Duration(milliseconds: 100),
                          curve: Curves.linear),
                    ],
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText('Author: ${randomQuote!.author}',
                          textStyle: const TextStyle(fontSize: 18),
                          speed: const Duration(milliseconds: 100),
                          curve: Curves.linear),
                    ],
                  ),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: fetchRandomData,
            child: const Text('Load'),
          ),
        ],
      ),
    );
  }
}
