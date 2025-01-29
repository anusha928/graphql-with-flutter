import 'package:anilist_graphql/core/model/anime_model.dart';
import 'package:equatable/equatable.dart';

abstract class PaginationState extends Equatable {}

class PaginationInitial extends PaginationState {
  @override
  List<Object?> get props => [];
}

class PaginationLoaded extends PaginationState {
  final List<AnimeModel> animeList;

  PaginationLoaded({required this.animeList});

  @override
  List<Object?> get props => [animeList];
}

class PaginationLoading extends PaginationState {
  final List<AnimeModel> oldAnimeList;
  final bool isFirstFetch;

  PaginationLoading(this.oldAnimeList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldAnimeList, isFirstFetch];
}

class PaginationError extends PaginationState {
  final String errorMessage;

  PaginationError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
