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
        body: Center(
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Input for hostName
                        TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Hostname'),
                              hintText: 'IP or domain',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the hostname';
                              }
                              // test value to be IP address or a hostname
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
                        // button
                      ],
                    )))));
  }
}
