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
  GraphQLClient client = getClient();

  fetchInfo() async {
    if (state is PaginationLoading) return;
    final currentState = state;
    var oldAnimeList = <AnimeModel>[];
    if (currentState is PaginationLoaded) {
      oldAnimeList = currentState.animeList;
    }
    emit(PaginationLoading(oldAnimeList, isFirstFetch: page == 1));
    try {
      final newAnimeList = await graphqlService.fetchAnimeList(client, page);
      page++;
      final updatedAnimeList = List<AnimeModel>.from(oldAnimeList)
        ..addAll(newAnimeList);
      emit(PaginationLoaded(animeList: updatedAnimeList));
    } catch (e) {
      emit(PaginationError(errorMessage: "Failed to fetch data: $e"));
    }
  }

  refreshData() async {
    page = 1;
    emit(PaginationInitial()); // Reset the state
    fetchInfo();
  }
}
