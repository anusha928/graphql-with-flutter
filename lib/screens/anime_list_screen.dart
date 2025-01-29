import 'dart:async';
import 'package:anilist_graphql/bloc/anime_paginated_bloc.dart';
import 'package:anilist_graphql/bloc/pagination_state.dart';
import 'package:anilist_graphql/core/model/anime_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeListScreen extends StatelessWidget {
  final scrollController = ScrollController();

  AnimeListScreen({super.key});

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        BlocProvider.of<AnimePaginatedCubit>(context).fetchInfo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    BlocProvider.of<AnimePaginatedCubit>(context).fetchInfo();
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<AnimePaginatedCubit>(context).refreshData();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("The Anime List"),
          ),
          body: createAnimeList()),
    );
  }

  createAnimeList() {
    return BlocBuilder<AnimePaginatedCubit, PaginationState>(
      builder: (context, state) {
        List<AnimeModel> animeList = [];

        if (state is PaginationLoading && state.isFirstFetch) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PaginationLoading) {
          animeList = state.oldAnimeList;
        } else if (state is PaginationLoaded) {
          animeList = state.animeList;
        } else if (state is PaginationError) {
          // Show an error message
          return Center(child: Text(state.errorMessage));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: animeList.length + 1,
          itemBuilder: (context, index) {
            if (index < animeList.length) {
              return buildAnimeItem(animeList[index]);
            } else {
              if (state is PaginationLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox
                    .shrink(); // Hide the indicator when not loading
              }
            }
          },
        );
      },
    );
  }

  Widget buildAnimeItem(AnimeModel anime) {
    return Column(
      children: [
        Image.network(anime.coverImage.medium),
        Container(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(
              anime.title.english ?? 'Unknown title',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
                anime.genere), // Be sure to fix the typo 'genere' to 'genre'
          ),
        ),
      ],
    );
  }
}
