import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../data.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Hero(
        tag: 'settings',
        flightShuttleBuilder: (context, anim, dire, cont1, cont2) => dire == HeroFlightDirection.push ? Container(
          margin: EdgeInsets.symmetric(vertical: 84, horizontal: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).canvasColor
          ),
          height: 208,
        ) : Icon(Icons.settings_outlined, color: Theme.of(context).primaryColorLight.withOpacity(0.25)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 84, horizontal: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).canvasColor
          ),
          height: 264,
          child: ListTileTheme(
            iconColor: Theme.of(context).primaryColorLight,
            contentPadding: EdgeInsets.symmetric(horizontal: 24),
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: Navigator.of(context).pop,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 24),
                              child: Text(
                                'Actrifier',
                                style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              height: 2,
                            ),
                            SwitchListTile(
                              secondary: Icon(Icons.search_outlined),
                              value: App.of(context).instantSearch,
                              onChanged: (value) => setState(() => App.of(context).instantSearch = value),
                              title: Text('Instant search', style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),),
                            ),
                            ListTile(
                              leading: Icon(Icons.policy_outlined),
                              title: Text('Privacy policy', style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),),
                              onLongPress: () async => debugPrint(await App.of(context).firebaseToken),
                            ),
                            ListTile(
                              leading: Icon(Icons.text_snippet_outlined),
                              title: Text('Open-source licences', style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),),
                              onTap: () => showLicensePage(context: context),
                            ),
                            Divider(
                              thickness: 2,
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: FutureBuilder<PackageInfo>(
                                future: () async {
                                  return await PackageInfo.fromPlatform();
                                }(),
                                builder: (context, snapshot) => Row(
                                  mainAxisAlignment: snapshot.hasData && !snapshot.hasError ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Created by oqtavios & Joseph Parker', style: Theme.of(context).textTheme.overline),
                                    snapshot.hasData && !snapshot.hasError ? Text('v${snapshot.data!.version}', style: Theme.of(context).textTheme.overline) : Container(),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
