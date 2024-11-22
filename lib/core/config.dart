class Config {
  factory Config() {
    return _config;
  }
  Config._internal();

  static final Config _config = Config._internal();
  static String graphUrl = "https://graphql.anilist.co";
}
