import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_provider/home_page_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageModel>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            value.addItem("new item");
          }),
          child: const Text("+"),
        ),
        body: ListView(
          children: value.items.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }
}
