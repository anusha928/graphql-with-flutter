import 'package:anilist_graphql/core/config.dart';
import 'package:graphql/client.dart';

String uri = Config.graphUrl;

GraphQLClient getClient() {
  final HttpLink link = HttpLink(
    uri,
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );
}
