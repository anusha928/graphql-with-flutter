class Title {
  final String romaji;
  final String english;
  final String native;

  Title({required this.romaji, required this.english, required this.native});
  static Title fromMap(Map<String, dynamic> map) => Title(
      romaji: map['romaji'] ?? '',
      english: map['english'] ?? '',
      native: map['native'] ?? '');
}
