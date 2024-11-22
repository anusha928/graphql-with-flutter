import 'package:anilist_graphql/bloc/pagination_state.dart';
import 'package:anilist_graphql/core/api/graphql_provider.dart';
import 'package:anilist_graphql/core/graphql_service.dart';
import 'package:anilist_graphql/core/model/anime_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';

class AnimePaginatedCubit extends Cubit<PaginationState> {
  final GraphqlService graphqlService;
  AnimePaginatedCubit({required this.graphqlService})
      : super(PaginationInitial());

  int page = 1;

  fetchInfo() async {
    if (state is PaginationLoading) return;
    final currentState = state;
    var oldAnimeList = <AnimeModel>[];
    if (currentState is PaginationLoading) {
      oldAnimeList = currentState.oldAnimeList;
    }
    emit(PaginationLoading(oldAnimeList, isFirstFetch: page == 1));
    GraphQLClient client = getClient();

    await graphqlService.fetchAnimeList(client, page, 10).then((value) {
      page++;
      final animeList = (state as PaginationLoading).oldAnimeList;
      animeList.addAll(value);

      emit(PaginationLoaded(animeList: animeList));
    });
  }
}
