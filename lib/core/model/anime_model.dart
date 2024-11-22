import 'package:anilist_graphql/core/model/title.dart';

class AnimeModel {
  final int? id;
  final Title title;
  final String genere;
  final CoverImage coverImage;

  AnimeModel(
      {this.id,
      required this.title,
      required this.genere,
      required this.coverImage});
  static AnimeModel fromMap({required Map map}) => AnimeModel(
      id: map['id'] ?? '',
      title: Title.fromMap(map['title'] ?? ""),
      genere: map['genere'] ?? '',
      coverImage: CoverImage.fromMap(map['coverImage'] ?? ''));
}

class CoverImage {
  final String medium;

  CoverImage({required this.medium});
  static CoverImage fromMap(Map<String, dynamic> map) =>
      CoverImage(medium: map['medium'] ?? '');
}
