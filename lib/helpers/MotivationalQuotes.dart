import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class RandomQuoteWidget extends StatefulWidget {
  @override
  _RandomQuoteWidgetState createState() => _RandomQuoteWidgetState();
}

class _RandomQuoteWidgetState extends State<RandomQuoteWidget> {
  late String _randomQuote = '..loading';

  @override
  void initState() {
    super.initState();
    _fetchRandomQuote();
  }

  Future<void> _fetchRandomQuote() async {
    try {
      final quotes = await _loadQuotesFromJson();
      final random = Random();
      final randomIndex = random.nextInt(quotes.length);
      setState(() {
        _randomQuote = quotes[randomIndex]['quote'];
      });
    } catch (e) {
      print('Error fetching random quote: $e');
    }
  }

  Future<List<dynamic>> _loadQuotesFromJson() async {
    try {
      final String raw = await DefaultAssetBundle.of(context)
          .loadString('assets/data/quotes.json');
      final List<dynamic> jsonList = json.decode(raw);
      return jsonList;
    } catch (e) {
      print('Error loading JSON file: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          _randomQuote,
          style: const TextStyle(
            color: Colors.white, // Change text color to black
            fontSize: 16, // Adjust the font size here
            fontFamily: 'Lato', // Replace 'CustomFont' with your font family
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
