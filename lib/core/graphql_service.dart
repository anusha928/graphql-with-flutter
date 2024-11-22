import 'package:anilist_graphql/core/model/anime_model.dart';
import 'package:graphql/client.dart';

String getAnimeQuery = """
  query (\$page: Int, \$perPage: Int) {
    Page(page: \$page, perPage: \$perPage) {
      media(type: ANIME) {
        id
        title {
          romaji
          english
          native
        }
        coverImage {
          medium
        }
        genres
      }
    }
  }
""";

class GraphqlService {
  Future<List<AnimeModel>> fetchAnimeList(GraphQLClient client, int page, int perPage) async {
    try {
      final variables = {
        'page': page,
        'perPage': perPage,
      };

      final QueryOptions options = QueryOptions(
        document: gql(getAnimeQuery),
        variables: variables,
      );

      final QueryResult result = await client.query(options);
      if (result.hasException) {
        throw Exception(result.exception);
      }

      List? res = result.data?['Page']['media'];
      if (res == null || res.isEmpty) {
        return [];
      }
      List<AnimeModel> animeList =
          res.map((e) => AnimeModel.fromMap(map: e)).toList();
      return animeList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
