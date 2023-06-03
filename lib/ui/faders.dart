import 'package:flutter/material.dart';
import 'package:matrixmix/models.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../settings.dart';

class FaderListWidget extends StatefulWidget {
  final int faderGroupId;

  const FaderListWidget({super.key, required this.faderGroupId});

  @override
  State<StatefulWidget> createState() => _FaderListWidgetState();
}

class _FaderListWidgetState extends State<FaderListWidget> {
  late final FaderGroupConfig _groupConfig;

  @override
  void initState() {
    super.initState();
    _groupConfig = getFaderGroupConfigMainPage(widget.faderGroupId);
  }

  Column buildFader(index) {
    var faders = _groupConfig.faders[index];
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
                });
              },
            )),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  faders.panFader.value = 0;
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
    var faderWidgets = <Widget>[];
    for (var index = 0; index < _groupConfig.faders.length; index++) {
      faderWidgets.add(buildFader(index));
    }

    return Container(
        padding: const EdgeInsets.all(8.0),
        height: 400,
        child: Container(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: faderWidgets,
            )));
  }
}
