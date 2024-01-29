import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_buzz/routes/app_route_consts.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String backdropPath;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final bool video;
  final double voteAverage;
  final int voteCount;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter.of(context);

    return Container(
      margin: const EdgeInsets.all(5),
      height: 300,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          router.pushNamed(
            moviePageRoute,
            pathParameters: {'movieId': widget.id.toString()},
          );
        },
        splashColor: Colors.white.withAlpha(30),
        child: Ink(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Image does not exist for this movie',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Title: ${widget.originalTitle}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              imageUrl:
                  'https://image.tmdb.org/t/p/original/${widget.backdropPath}',
              fadeOutDuration: const Duration(milliseconds: 250),
              fadeInDuration: const Duration(milliseconds: 250),
              placeholder: (context, url) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary),
                );
              },
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
