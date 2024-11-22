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
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<AnimePaginatedCubit>(context).fetchInfo();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<AnimePaginatedCubit>(context).fetchInfo();
    return Scaffold(
        appBar: AppBar(
          title: Text("The Anime List"),
        ),
        body: createAnimeList());
  }

  createAnimeList() {
    return BlocBuilder<AnimePaginatedCubit, PaginationState>(
      builder: (context, state) {
        if (state is PaginationLoading && state.isFirstFetch) {
          return const Center(child: CircularProgressIndicator());
        }
        List<AnimeModel> animeList = [];
        bool isLoading = false;

        if (state is PaginationLoading) {
          animeList = state.oldAnimeList;
          isLoading = true;
        } else if (state is PaginationLoaded) {
          animeList = state.animeList;
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: animeList.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < animeList.length) {
              return Column(
                children: [
                  Image.network(animeList[index].coverImage.medium),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        animeList[index].title.english ?? 'Unknown titles',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: Text(animeList[index].genere),
                    ),
                  ),
                ],
              );
            } else {
              Timer(const Duration(milliseconds: 30), () {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
