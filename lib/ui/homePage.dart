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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    int length = context.read<DSPServerModel>().faderGroups.length;
    _tabController = TabController(vsync: this, length: length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Tab> getTabs(DSPServerModel dspServer) {
    List<Tab> tabs = [];
    dspServer.faderGroups.forEach((key, value) {
      tabs.add(Tab(text: value.name));
    });
    return tabs;
  }

  List<FaderListWidget> getFaderListWidgets(DSPServerModel dspServer) {
    List<FaderListWidget> groups = [];
    dspServer.faderGroups.forEach((key, value) {
      groups.add(FaderListWidget(faderGroupId: key));
    });
    return groups;
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
          bottom: TabBar(controller: _tabController, tabs: getTabs(dspServer)),
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
            child: TabBarView(
                controller: _tabController,
                children: getFaderListWidgets(dspServer))));
  }
}
