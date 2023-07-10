// title text widget
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';

class TitleTextWidget extends StatefulWidget {
  const TitleTextWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  // override create state
  @override
  State<TitleTextWidget> createState() => _TitleTextWidgetState();
}

class _TitleTextWidgetState extends State<TitleTextWidget> {
  void onCheckButtonPressed(DSPServerModel dspServer) async {
    await dspServer.connect();
  }

  List<Widget> getConnectionPart(bool isConnected, DSPServerModel dspServer) {
    List<Widget> children = [Text('${widget.title}: ')];
    if (isConnected) {
      children.add(
          const Text('online', style: TextStyle(color: Colors.green)));
    } else {
      children.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
              onPressed: () => onCheckButtonPressed(dspServer),
              child: const Text('reconnect'))));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    var dspServer = context.watch<DSPServerModel>();
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...getConnectionPart(dspServer.isConnected, dspServer)]);
  }
}
