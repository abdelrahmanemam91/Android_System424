import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search_screen';

  const SearchScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('The seaech screen is build');
    return Scaffold(
      backgroundColor: Colors.black,
      body: TextFormField(),
    );
  }
}
