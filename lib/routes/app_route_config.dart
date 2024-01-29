import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_buzz/components/smol/scaffold_wrapper.dart';
import 'package:movie_buzz/pages/home_page.dart';
import 'package:movie_buzz/pages/movie_collection.dart';
import 'package:movie_buzz/pages/movies.dart';
import 'package:movie_buzz/pages/single_movie_page.dart';
import 'package:movie_buzz/routes/app_route_consts.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    // initialLocation: '/collection/86311/299534',
    routes: [
      GoRoute(
        path: '/',
        name: homePageRoute,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ScaffoldWrapper(
              child: HomePage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/movies/:movieId',
        name: moviePageRoute,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: ScaffoldWrapper(
              child: SingleMoviePage(
                movieId: state.pathParameters['movieId']!,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/collection/:collectionId/:cameFrom',
        name: movieCollectionPageRoute,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: MovieCollections(
              collectionId: state.pathParameters['collectionId']!,
              cameFrom: state.pathParameters['cameFrom']!,
            ),
          );
        },
      ),
      GoRoute(
        path: '/discover_movies',
        name: discoverMoviesPageRoute,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ScaffoldWrapper(
              child: MoviePage(),
            ),
          );
        },
      ),
    ],
  );
}
