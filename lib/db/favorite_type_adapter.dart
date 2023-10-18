import 'package:hive/hive.dart';

part 'favorite_type_adapter.g.dart';

@HiveType(typeId: 1)
class Favorite {
  Favorite({
    required this.id,
    required this.photographer,
    required this.photographerUrl,
    required this.avgColor,
    required this.imgPortrait,
    required this.imgSmall,
    required this.width,
    required this.height,
  });

  @HiveField(0)
  int id;
  @HiveField(1)
  String photographer;
  @HiveField(2)
  String photographerUrl;
  @HiveField(3)
  String avgColor;
  @HiveField(4)
  String imgPortrait;
  @HiveField(5)
  String imgSmall;
  @HiveField(6)
  String width;
  @HiveField(7)
  String height;
}
