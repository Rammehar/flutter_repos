import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'post_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Deep Links With Firebase",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => const HomeScreen(),
        "/post-detail": (context) => const PostDetailScreen(),
      },
    );
  }
}
