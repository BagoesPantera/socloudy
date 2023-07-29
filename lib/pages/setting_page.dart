import 'package:flutter/material.dart';
import 'package:socloudy/pages/policy_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Version",style: TextStyle(fontSize: 20, color: Colors.white)),
                Text("1.0",style: TextStyle(fontSize: 13, color: Colors.white70))
              ],
            ),
            InkWell(
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const PolicyPage())); }, // Handle your callback
              child: Ink( width: 900,
                child:Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text("Privacy Policy", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
