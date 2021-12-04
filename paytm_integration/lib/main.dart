import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import 'HomeScreen1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter App'),
        ),
        body: HomeScreen1(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String mid = "", orderId = "", amount = "";
  String result = "";
  bool isStaging = false;
  bool isApiCallInProgress = false;
  String callbackUrl = "";
  bool restrictAppInvoke = false;

  @override
  void initState() {
    print("initState");
    super.initState();
  }

  //below function used to generate txnToken calling api
  Future<String> fetchCheckSum() async {
    String txnToken = "";
    final response = await http.post(
        "http://api.rswebteksolutions.com/sample.php",
        body: {'orderId': '$orderId'});

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      txnToken = jsonResponse['txnToken'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      txnToken = "";
    }
    print(txnToken);
    return txnToken;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              EditText('Merchant ID', mid, onChange: (val) => mid = val),
              EditText('Order ID', orderId, onChange: (val) => orderId = val),
              EditText('Amount', amount, onChange: (val) => amount = val),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Theme.of(context).buttonColor,
                      value: isStaging,
                      onChanged: (bool val) {
                        setState(() {
                          isStaging = val;
                        });
                      }),
                  Text("Staging")
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Theme.of(context).buttonColor,
                      value: restrictAppInvoke,
                      onChanged: (bool val) {
                        setState(() {
                          restrictAppInvoke = val;
                        });
                      }),
                  Text("Restrict AppInvoke")
                ],
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: RaisedButton(
                  onPressed: isApiCallInProgress
                      ? null
                      : () {
                          _startTransaction();
                        },
                  child: Text('Start Transcation'),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Text("Message : "),
              ),
              Container(
                child: Text(result),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startTransaction() async {
    var txnToken = await fetchCheckSum();
    print("MyTokenIS: $txnToken");
    if (txnToken.isEmpty) {
      return;
    }
    try {
      //amOZIA74653507854205
      var response = AllInOneSdk.startTransaction(
          mid, orderId, amount, txnToken, null, isStaging, restrictAppInvoke);
      response.then((value) {
        print(value);
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            result = onError.message + " \n  " + onError.details.toString();
          });
        } else {
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      result = err.message;
    }
  }
}

class EditText extends StatelessWidget {
  final String text, value;
  final Function onChange;
  EditText(this.text, this.value, {this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.fromLTRB(12, 8, 0, 0),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: TextField(
            controller: TextEditingController(text: value),
            onChanged: onChange,
            decoration: InputDecoration(
              hintText: 'Enter ${text}',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
