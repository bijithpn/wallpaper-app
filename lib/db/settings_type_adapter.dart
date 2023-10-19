import 'package:hive/hive.dart';

part 'settings_type_adapter.g.dart';

@HiveType(typeId: 1)
class Setting {
  Setting({
    required this.isDark,
    required this.onWifi,
    required this.onCharging,
    required this.onidle,
    required this.screen,
    required this.interval,
  });

  @HiveField(0)
  bool isDark;
  @HiveField(1)
  bool onWifi;
  @HiveField(2)
  bool onCharging;
  @HiveField(3)
  bool onidle;
  @HiveField(4)
  int screen;
  @HiveField(5)
  String interval;
}
