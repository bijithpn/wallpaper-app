// To parse this JSON data, do
//
//     final previewImage = previewImageFromJson(jsonString);

import 'dart:convert';

List<PreviewImage> previewImageFromJson(String str) => List<PreviewImage>.from(
    json.decode(str).map((x) => PreviewImage.fromJson(x)));

String previewImageToJson(List<PreviewImage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PreviewImage {
  String id;
  int width;
  int height;
  String color;
  String blurHash;
  String? description;
  String altDescription;
  Urls urls;
  User user;

  PreviewImage({
    required this.id,
    required this.width,
    required this.height,
    required this.color,
    required this.blurHash,
    required this.description,
    required this.altDescription,
    required this.urls,
    required this.user,
  });

  factory PreviewImage.fromJson(Map<String, dynamic> json) => PreviewImage(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"],
        altDescription: json["alt_description"],
        urls: Urls.fromJson(json["urls"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "description": description,
        "alt_description": altDescription,
        "urls": urls.toJson(),
        "user": user.toJson(),
      };
}

class User {
  String id;
  DateTime updatedAt;
  String username;
  String name;
  String firstName;
  String? lastName;
  String? twitterUsername;
  String? portfolioUrl;
  String? bio;
  String? location;
  ProfileImage profileImage;
  String instagramUsername;

  Social social;

  User({
    required this.id,
    required this.updatedAt,
    required this.username,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.twitterUsername,
    required this.portfolioUrl,
    required this.bio,
    required this.location,
    required this.profileImage,
    required this.instagramUsername,
    required this.social,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        twitterUsername: json["twitter_username"] ?? "",
        portfolioUrl: json["portfolio_url"] ?? "",
        bio: json["bio"],
        location: json["location"],
        profileImage: ProfileImage.fromJson(json["profile_image"]),
        instagramUsername: json["instagram_username"] ?? "",
        social: Social.fromJson(json["social"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "twitter_username": twitterUsername,
        "portfolio_url": portfolioUrl,
        "bio": bio,
        "location": location,
        "profile_image": profileImage.toJson(),
        "instagram_username": instagramUsername,
        "social": social.toJson(),
      };
}

class ProfileImage {
  String small;
  String medium;
  String large;

  ProfileImage({
    required this.small,
    required this.medium,
    required this.large,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        small: json["small"] ?? "",
        medium: json["medium"] ?? "",
        large: json["large"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
        "large": large,
      };
}

class Social {
  String instagramUsername;
  String? portfolioUrl;
  String? twitterUsername;
  dynamic paypalEmail;

  Social({
    required this.instagramUsername,
    required this.portfolioUrl,
    required this.twitterUsername,
    required this.paypalEmail,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        instagramUsername: json["instagram_username"] ?? "",
        portfolioUrl: json["portfolio_url"] ?? "",
        twitterUsername: json["twitter_username"] ?? "",
        paypalEmail: json["paypal_email"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "instagram_username": instagramUsername,
        "portfolio_url": portfolioUrl,
        "twitter_username": twitterUsername,
        "paypal_email": paypalEmail,
      };
}

class Urls {
  String raw;
  String full;
  String regular;
  String small;
  String thumb;
  String smallS3;

  Urls({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
    required this.smallS3,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
      );

  Map<String, dynamic> toJson() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
        "small_s3": smallS3,
      };
}
