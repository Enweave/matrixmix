import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'common.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TitleTextWidget(title: widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.pushReplacement('/');
            },
          ),
        ],
      ),
      body: const Center(
          child: Column(children: [

          ])),
    );
  }
}


