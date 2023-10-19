import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = true;
  bool onWifi = false, onCharging = false, onidle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            ListTile(
              leading: isDark
                  ? const Icon(Icons.dark_mode_outlined)
                  : const Icon(Icons.light_mode),
              title: const Text("Theme"),
              trailing: Switch(
                  value: isDark,
                  activeColor: Colors.grey,
                  inactiveThumbImage: const AssetImage("assets/images/sun.png"),
                  activeThumbImage:
                      const AssetImage("assets/images/moondark.png"),
                  onChanged: (value) => setState(() {
                        isDark = value;
                      })),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                setState(() {
                  onWifi = !onWifi;
                });
              },
              leading: const Icon(Icons.wifi),
              title: const Text("On Wi-Fi"),
              subtitle:
                  const Text("Device must be connected to a Wi-Fi network"),
              trailing: Checkbox(
                  value: onWifi,
                  activeColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      onWifi = value!;
                    });
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.power),
              title: const Text("Charging"),
              onTap: () {
                setState(() {
                  onCharging = !onCharging;
                });
              },
              subtitle:
                  const Text("Device must be connected to a power source"),
              trailing: Checkbox(
                  activeColor: Colors.grey,
                  value: onCharging,
                  onChanged: (value) {
                    setState(() {
                      onCharging = value!;
                    });
                  }),
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: const Text("Idle"),
              onTap: () {
                setState(() {
                  onidle = !onidle;
                });
              },
              subtitle: const Text("Device must be inactive"),
              trailing: Checkbox(
                  value: onidle,
                  activeColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      onidle = value!;
                    });
                  }),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.schedule),
              title: Text("Interval"),
              subtitle: Text("Each wallpaper will last a minimum of 3 hour"),
            ),
            const ListTile(
              leading: Icon(Icons.wallpaper_rounded),
              title: Text("Screen"),
              subtitle: Text("Home and Lock Screen"),
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "1.0.1",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
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
