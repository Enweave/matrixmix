import 'package:flutter/material.dart';
import 'package:matrixmix/models.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:throttled/throttled.dart';

import '../settings.dart';

class FaderListWidget extends StatefulWidget {
  final int faderGroupId;

  const FaderListWidget({super.key, required this.faderGroupId});

  @override
  State<StatefulWidget> createState() => _FaderListWidgetState();
}

class _FaderListWidgetState extends State<FaderListWidget> {
  void sendFaderValues(dspServer) {
    throttle('dsp', dspServer.sendFaderValues,
        cooldown: FADER_SEND_INTERVAL, leaky: true);
  }

  Column buildFader(int index, DSPServerModel dspServer) {
    var faders = dspServer.faderGroups[widget.faderGroupId]?.faders[index];
    if (faders == null) {
      return const Column(children: []);
    }
    var columnChildren = [
      // bold text
      Container(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(faders.name,
              style: const TextStyle(fontWeight: FontWeight.bold))),
      Expanded(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(children: [
          Text(faders.volumeFader.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w300)),
          Expanded(
              child: SfSlider.vertical(
            min: faders.volumeFader.minValue.toDouble(),
            max: faders.volumeFader.maxValue.toDouble(),
            showDividers: true,
            showTicks: true,
            interval: 10,
            value: faders.volumeFader.value.toDouble(),
            enableTooltip: false,
            onChanged: (dynamic value) {
              setState(() {
                faders.volumeFader.value = value.toInt();
                sendFaderValues(dspServer);
              });
            },
          ))
        ]),
        Column(
          children: [
            Text(faders.panFader.value.toString(),
                style: const TextStyle(fontWeight: FontWeight.w300)),
            Expanded(
                child: SfSlider.vertical(
              min: faders.panFader.minValue.toDouble(),
              max: faders.panFader.maxValue.toDouble(),
              showDividers: true,
              showTicks: true,
              interval: 10,
              value: faders.panFader.value.toDouble(),
              enableTooltip: false,
              onChanged: (dynamic value) {
                setState(() {
                  faders.panFader.value = value.toInt();
                  sendFaderValues(dspServer);
                });
              },
            )),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  faders.panFader.value = 0;
                  sendFaderValues(dspServer);
                });
              },
              child: const Text('C'),
            )
          ],
        )
      ]))
    ];

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: columnChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dspServer = context.watch<DSPServerModel>();

    var faderWidgets = <Widget>[];
    List<StereoFader>? faders =
        dspServer.faderGroups[widget.faderGroupId]?.faders;
    if (faders == null) {
      return const Text('No faders');
    }
    for (var index = 0; index < faders.length; index++) {
      faderWidgets.add(buildFader(index, dspServer));
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(8, 50, 8, 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: faderWidgets,
        ));
  }
}
