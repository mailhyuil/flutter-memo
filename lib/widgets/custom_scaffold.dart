import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;
  const CustomScaffold(
      {Key? key, required this.appBarTitle, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appBarTitle),
      ),
      body: body,
    );
  }
}
