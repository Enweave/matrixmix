import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixmix/settings.dart';
import 'package:matrixmix/ui/faders.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import 'common.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dspServer = context.watch<DSPServerModel>();
    _tabController.index = dspServer.currentSubmix;
    _tabController.addListener(() {
      dspServer.updateCurrentSubmix(_tabController.index.toInt());
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TitleTextWidget(title: widget.title),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Main'),
          Tab(text: 'Group 1'),
          Tab(text: 'Group 2'),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // go to settings route
              context.goNamed(SETTINGS_PAGE);
            },
          ),
        ],
      ),
      body: Center(
          child: TabBarView(controller: _tabController, children: const [
        FaderListWidget(faderGroupId: 0),
        FaderListWidget(faderGroupId: 1),
        FaderListWidget(faderGroupId: 2),
      ])),
    );
  }
}
