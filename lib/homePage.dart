import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:matrixmix/ui/faders.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<http.Response> _fetchGet() {
  //   return http.get(Uri.parse('http://192.168.4.1/hello'));
  // }
  //
  // Future<FadersData> _getFadersData() async {
  //   final response = await http.get(Uri.parse('http://192.168.4.1/faders'));
  //   // parse the response
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response, then parse the JSON.
  //     final parsed = jsonDecode(response.body);
  //     return FadersData.fromJson(parsed);
  //   } else {
  //     // If the server did not return a 200 OK response, then throw an exception.
  //     throw Exception('Failed to load faders');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
          child: DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Column(children: [
                Expanded(
                  flex: 4,
                    child: TabBarView(children: [
                  FaderListWidget(faderGroupId: 0),
                  FaderListWidget(faderGroupId: 1),
                  FaderListWidget(faderGroupId: 2),
                ])),
                Expanded(
                  flex: 1,
                    child: TabBar(tabs: [
                  Tab(text: 'Main'),
                  Tab(text: 'Group 1'),
                  Tab(text: 'Group 2'),
                ]))
              ]))),
    );
  }
}
