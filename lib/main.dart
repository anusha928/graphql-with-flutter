import 'package:anilist_graphql/bloc/anime_paginated_bloc.dart';
import 'package:anilist_graphql/core/graphql_service.dart';
import 'package:anilist_graphql/screens/anime_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GraphqlService>(
          create: (_) => GraphqlService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) =>
            AnimePaginatedCubit(graphqlService: context.read<GraphqlService>()),
        child: AnimeListScreen(),
      ),
    );
  }
}
