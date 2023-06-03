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
  // override build
  @override
  Widget build(BuildContext context) {
    var dspServer = context.watch<DSPServerModel>();
    return Text('${widget.title} <${dspServer.isConnected ? '(connected)' : 'offline'}> ${dspServer.currentSubmix}');
  }
}