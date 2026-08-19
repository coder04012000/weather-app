import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/homemodel.dart';
import '../provider/homeprovider.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Search City")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter city",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Provider.of<HomePageProvider>(context, listen: false)
                    .addCity(controller.text);

                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}