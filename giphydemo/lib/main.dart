import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_demo/api/giphy_api.dart';
import 'package:giphy_demo/models/giphy_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  // List<Map<String, dynamic>> searchResult = [];
  List<GiphyModel> searchResult = [];
  bool isLoading = false;

  //
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading = true;
      final data = await GiphyApi.searchGiphy(query);
      setState(() {
        searchResult = data;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.menu),
            suffixIcon: Icon(Icons.search),
            hintText: "Search here..",
            enabledBorder: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
      body: searchResult.isEmpty
          ? const Center(
              child: Text("No Records"),
            )
          : !isLoading
              ? ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, index) {
                    final giphyModel = searchResult[index];
                    return GiphyCard(giphyModel);
                    // return ListTile(
                    //   title: Text(giphyModel.title),
                    // );
                    // return ListTile(
                    //   leading: Image.network(
                    //       searchResult[index]['images']['original']['url']),
                    //   title: Text(searchResult[index]['title']),
                    // );
                  },
                )
              : const Center(
                  child: Text("Please wait"),
                ),
    );
  }
}

class GiphyCard extends StatelessWidget {
  const GiphyCard(this._giphyModel, {Key? key}) : super(key: key);
  final GiphyModel _giphyModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: 210,
        child: Card(
          child: Row(
            children: [
                SizedBox(
                 height: 210,
                width: 210,
                child: Image.network(_giphyModel.url,fit: BoxFit.cover,),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_giphyModel.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
