import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpensePredictionScreen extends StatefulWidget {
  @override
  _ExpensePredictionScreenState createState() =>
      _ExpensePredictionScreenState();
}

class _ExpensePredictionScreenState extends State<ExpensePredictionScreen> {
  List<List<double>> predictions = [];
  bool isLoading = false;
  String error = '';

  void predictExpenses() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final response = await http.post(
Uri.parse('http://127.0.1.1:5111/predict'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, List<int>>{
          'categories': [0, 1, 2, 3],
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> results = jsonDecode(response.body);
        setState(() {
          predictions = results
              .map<List<double>>(
                  (result) => [result[0].toDouble(), result[1].toDouble()])
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to connect to the server';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    predictExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Prediction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Predicted expenses:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            isLoading
                ? CircularProgressIndicator()
                : error.isNotEmpty
                    ? Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  'Predicted expense for category ${predictions[index][0]} is ${predictions[index][1]}'),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
