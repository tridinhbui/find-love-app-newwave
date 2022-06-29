import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commons/image_paths.dart';
import '../user_info/user_info_page.dart';
import '../utils/authentication.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2
  String? _selectedLocation;
  int index_1 = 0;
  String? selected = null;
  bool _isSigningIn = false;
  List<Map<String, String>> language = [
    {
      "lang": "en",
      "image": "assets/icons/flag_usa.webp ",
    },
    {
      "lang": "vie",
      "image": "assets/icons/flag_vn.png ",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          DropdownButton<String>(
            hint: Text('Please choose a location'), // Not necessary for Option 1
            value: _selectedLocation,
            onChanged: (newValue) {
              // setState(() {
              //   _selectedLocation = newValue;
              // });
            },
            items: _locations.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),




        ]),
      ),
    );
  }

}
