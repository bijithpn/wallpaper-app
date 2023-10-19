import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/provider/provider.dart';
import 'package:flutter_wallpaper_app/provider/settings_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Consumer<SettingProvider>(
        builder: (context, setting, _) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: ValueListenableBuilder(
              valueListenable: Hive.box('settingBox').listenable(),
              builder: (context, box, child) {
                bool isDark = box.get('darkMode', defaultValue: true);
                bool onidle = box.get('onIdle', defaultValue: false);
                bool onCharging = box.get('onCharge', defaultValue: false);
                bool onWifi = box.get('onWifi', defaultValue: false);
                return Column(
                  children: [
                    ListTile(
                      leading: isDark
                          ? const Icon(Icons.dark_mode_outlined)
                          : const Icon(Icons.light_mode),
                      title: const Text("Theme"),
                      trailing: Switch(
                          value: isDark,
                          activeColor: Colors.grey,
                          inactiveThumbImage:
                              const AssetImage("assets/images/sun.png"),
                          activeThumbImage:
                              const AssetImage("assets/images/moondark.png"),
                          onChanged: (value) {
                            setting.toggleTheme(value);
                            box.put('darkMode', !isDark);
                            notifyListeners();
                          }),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        box.put('onWifi', !onWifi);
                      },
                      leading: const Icon(Icons.wifi),
                      title: const Text("On Wi-Fi"),
                      subtitle: const Text(
                          "Device must be connected to a Wi-Fi network"),
                      trailing: Checkbox(
                          value: onWifi,
                          activeColor: Colors.grey,
                          onChanged: (value) {
                            box.put('onWifi', !onWifi);
                            notifyListeners();
                          }),
                    ),
                    ListTile(
                      leading: const Icon(Icons.power),
                      title: const Text("Charging"),
                      onTap: () {
                        box.put('onCharge', !onCharging);
                      },
                      subtitle: const Text(
                          "Device must be connected to a power source"),
                      trailing: Checkbox(
                          activeColor: Colors.grey,
                          value: onCharging,
                          onChanged: (value) {
                            box.put('onCharge', !onCharging);
                            notifyListeners();
                          }),
                    ),
                    ListTile(
                      leading: const Icon(Icons.hourglass_empty),
                      title: const Text("Idle"),
                      onTap: () {
                        box.put('onIdle', !onidle);
                      },
                      subtitle: const Text("Device must be inactive"),
                      trailing: Checkbox(
                          value: onidle,
                          activeColor: Colors.grey,
                          onChanged: (value) {
                            box.put('onIdle', !onidle);
                            notifyListeners();
                          }),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text("Interval"),
                      subtitle:
                          Text("Each wallpaper will last a minimum of 3 hour"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.wallpaper_rounded),
                      title: Text("Screen"),
                      subtitle: Text("Home and Lock Screen"),
                    ),
                    const Divider(),
                    Consumer<ImageDownloadProvider>(
                      builder: (context, downloadProvider, _) {
                        return ListTile(
                          onTap: () {
                            downloadProvider.updatePath();
                            notifyListeners();
                          },
                          trailing: const Icon(Icons.edit_outlined),
                          leading: const Icon(Icons.download_done),
                          title: const Text("Download location"),
                          subtitle:
                              Text(downloadProvider.paths?.first ?? "n/a"),
                        );
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.share_outlined),
                      title: Text("Recommaend"),
                      subtitle: Text("Share this app with friends and family"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.forum_outlined),
                      title: Text("Send Feedback"),
                      subtitle: Text(
                          "Tell me what you think,suggest ideas, bug reports and improvements"),
                    ),
                    const Spacer(),
                    Text(
                      "App Version",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1.0.1",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 1,
      width: double.infinity,
    );
  }
}
