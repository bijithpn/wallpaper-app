import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_app/provider/provider.dart';
import 'package:flutter_wallpaper_app/screens/details/wallpaper_item.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                int wallpaperStatus =
                    box.get('wallpaperStatus', defaultValue: 3);
                return ListView(
                  children: [
                    ListTile(
                      leading: isDark
                          ? const Icon(Icons.dark_mode_outlined)
                          : const Icon(Icons.light_mode),
                      title: const Text("Theme"),
                      trailing: Switch(
                          value: isDark,
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveThumbImage:
                              const AssetImage("assets/images/sun.png"),
                          activeThumbImage:
                              const AssetImage("assets/images/moondark.png"),
                          onChanged: (value) {
                            setting.toggleTheme(value);
                            box.put('darkMode', !isDark);
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
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: onWifi,
                          onChanged: (value) {
                            box.put('onWifi', !onWifi);
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
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: onCharging,
                          onChanged: (value) {
                            box.put('onCharge', !onCharging);
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
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            box.put('onIdle', !onidle);
                          }),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text("Interval"),
                      subtitle:
                          Text("Each wallpaper will last a minimum of 3 hour"),
                    ),
                    ListTile(
                      onTap: () async {
                        int wallpaper = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WallpaperItemWIdget(
                                            title: "Home Screen",
                                            color:
                                                Theme.of(context).primaryColor,
                                            icon: Icons.home_rounded,
                                            function: () {
                                              Navigator.pop(context,
                                                  WallpaperManager.HOME_SCREEN);
                                            },
                                          ),
                                          WallpaperItemWIdget(
                                            title: "Lock Screen",
                                            color:
                                                Theme.of(context).primaryColor,
                                            icon: Icons.lock_outline,
                                            function: () {
                                              Navigator.pop(context,
                                                  WallpaperManager.LOCK_SCREEN);
                                            },
                                          ),
                                          WallpaperItemWIdget(
                                            title: "Both Screen",
                                            color:
                                                Theme.of(context).primaryColor,
                                            icon: Icons.wallpaper_outlined,
                                            function: () {
                                              Navigator.pop(context,
                                                  WallpaperManager.BOTH_SCREEN);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }) ??
                            WallpaperManager.BOTH_SCREEN;
                        box.put('wallpaperStatus', wallpaper);
                      },
                      leading: const Icon(Icons.wallpaper_rounded),
                      title: const Text("Screen"),
                      subtitle: Text(wallpaperStatus == 1
                          ? "Home Screen"
                          : wallpaperStatus == 2
                              ? "Lock Screen"
                              : "Home and Lock Screen"),
                    ),
                    const Divider(),
                    Consumer<ImageDownloadProvider>(
                      builder: (context, downloadProvider, _) {
                        return ListTile(
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {
                              downloadProvider.updatePath();
                            },
                          ),
                          leading: const Icon(Icons.download_done),
                          title: const Text("Download location"),
                          subtitle: Text(downloadProvider.paths!.isNotEmpty
                              ? downloadProvider.paths!.first
                              : "N/A"),
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
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "App Version",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1.0.1",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
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
