import 'package:flutter/material.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image(image: AssetImage('assets/images/socloudy.png'), width:300, height:100),
          ),

          Text("1. Lorem", style: TextStyle(fontSize: 25)),
          Text("1.1 Lorem ipsum dolor sit amet."),
          Text("Consectetur adipiscing elit. Mauris molestie fringilla turpis eu ullamcorper. Morbi quis nunc at nisl cursus sagittis aliquet a ipsum. Praesent sem odio, consequat vel sem eget, molestie facilisis orci. Nullam fermentum felis nunc, quis euismod velit malesuada in. Curabitur scelerisque cursus malesuada. Aliquam gravida orci vel justo aliquam accumsan. Vivamus blandit posuere lacus, vel tincidunt ligula imperdiet nec. In vel ex nec urna tristique cursus. Curabitur bibendum tortor vitae lobortis finibus. Integer non tristique felis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; In et augue purus. Cras pellentesque est at enim volutpat facilisis. Nunc scelerisque diam orci, id condimentum massa finibus ut. Suspendisse potenti.")
        ],
      ),
    );
  }
}
