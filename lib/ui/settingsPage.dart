import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixmix/models.dart';
import 'package:matrixmix/settings.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import 'common.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _saveSuccess = false;

  void onCheckButtonPressed(DSPServerModel dspServer) async {
    await dspServer.connect();
  }

  void onSaveButtonPressed(DSPServerModel dspServer) async {
    _saveSuccess = await dspServer.sendSave();
    // show dialog with result
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Save result'),
            content: Text(_saveSuccess
                ? 'Save successful'
                : 'Save failed. Please check your settings'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  List<Widget> getFormChildren(DSPServerModel dspServer) {
    bool isEnabled = !kIsWeb;
    List<Widget> children = <Widget>[
      // Input for hostName
      TextFormField(
          enabled: isEnabled,
          decoration: const InputDecoration(
            label: Text('Hostname'),
            hintText: 'IP or domain',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the hostname';
            }

            if (value == 'localhost') {
              return null;
            }

            if (!isIP(value) && !isFQDN(value)) {
              return 'Please enter a valid IP address or hostname';
            }
            return null;
          },
          initialValue: dspServer.hostName,
          onChanged: (value) {
            if (_formKey.currentState!.validate()) {
              dspServer.updateHostName(value);
            }
          }),
      // input for httpPort
      TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            label: Text('http port'),
            hintText: 'http port (80)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter port';
            }
            return null;
          },
          initialValue: dspServer.httpPort.toString(),
          onChanged: (value) {
            if (_formKey.currentState!.validate()) {
              dspServer.updateHttpPort(int.parse(value));
            }
          }),
      // input for wsPort
      TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            label: Text('ws port'),
            hintText: 'ws port (80)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter port';
            }
            return null;
          },
          initialValue: dspServer.wsPort.toString(),
          onChanged: (value) {
            if (_formKey.currentState!.validate()) {
              dspServer.updateWsPort(int.parse(value));
            }
          }),
    ];

    if (kIsWeb) {
      children.add(Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: const Text('Web version does not support changing host')));
    }

    children.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: ElevatedButton(
            onPressed: () => onCheckButtonPressed(dspServer),
            child: const Text('reconnect'))));

    children.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: MaterialButton(
            onPressed: () => onSaveButtonPressed(dspServer),
            child: const Text('save'))));

    return children;
  }

  @override
  Widget build(BuildContext context) {
    var dspServer = context.watch<DSPServerModel>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: TitleTextWidget(title: widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                context.goNamed(HOME_PAGE);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getFormChildren(dspServer))))));
  }
}
