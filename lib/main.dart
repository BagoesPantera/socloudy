import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:socloudy/pages/home_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Hide debug
    title: 'socloudy',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.transparent,
    ),
    home: const HomePage(),
  ));
}

