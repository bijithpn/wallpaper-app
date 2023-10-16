// To parse this JSON data, do
//
//     final previewImage = previewImageFromJson(jsonString);

import 'dart:convert';

PreviewImage previewImageFromJson(String str) =>
    PreviewImage.fromJson(json.decode(str));

String previewImageToJson(PreviewImage data) => json.encode(data.toJson());

class PreviewImage {
  List<Photo> photos;

  PreviewImage({
    required this.photos,
  });

  factory PreviewImage.fromJson(Map<String, dynamic> json) => PreviewImage(
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
      };
}

class Photo {
  int id;
  int width;
  int height;
  String url;
  String photographer;
  String photographerUrl;
  String avgColor;
  Src src;

  Photo({
    required this.id,
    required this.width,
    required this.photographerUrl,
    required this.height,
    required this.src,
    required this.url,
    required this.photographer,
    required this.avgColor,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        src: Src.fromJson(json["src"]),
        photographerUrl: json["photographer_url"],
        photographer: json["photographer"],
        avgColor: json["avg_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "url": url,
        "src": src.toJson(),
        "photographer": photographer,
        "photographer_url": photographerUrl,
        "avg_color": avgColor,
      };
}

class Src {
  String original;
  String large2X;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  Src({
    required this.original,
    required this.large2X,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory Src.fromJson(Map<String, dynamic> json) => Src(
        original: json["original"],
        large2X: json["large2x"],
        large: json["large"],
        medium: json["medium"],
        small: json["small"],
        portrait: json["portrait"],
        landscape: json["landscape"],
        tiny: json["tiny"],
      );

  Map<String, dynamic> toJson() => {
        "original": original,
        "large2x": large2X,
        "large": large,
        "medium": medium,
        "small": small,
        "portrait": portrait,
        "landscape": landscape,
        "tiny": tiny,
      };
}
