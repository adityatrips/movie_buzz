import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:movie_buzz/components/smol/draggable_home_wrapper.dart';
import 'package:movie_buzz/components/smol/eighteen_plus.dart';
import 'package:movie_buzz/routes/app_route_consts.dart';

class SingleMoviePage extends StatefulWidget {
  const SingleMoviePage({super.key, required this.movieId});

  final String movieId;

  @override
  State<SingleMoviePage> createState() => _SingleMoviePageState();
}

class _SingleMoviePageState extends State<SingleMoviePage> {
  late Future<Map<String, dynamic>> movieFuture;
  late Future<void> castFuture;

  Future<Map<String, dynamic>> _getOneMovie() async {
    final url =
        Uri.parse('https://api.themoviedb.org/3/movie/${widget.movieId}');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${dotenv.env['BEARER_TOKEN']}"
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _getCast() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieId}/credits');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer ${dotenv.env['BEARER_TOKEN']}"
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  @override
  void initState() {
    movieFuture = _getOneMovie();
    castFuture = _getCast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter.of(context);

    return FutureBuilder(
      future: movieFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Text('Error'),
            ),
          );
        }
        final Map<String, dynamic> movieDetails =
            snapshot.data as Map<String, dynamic>;
        return DraggableHomeWrapper(
          headerBottomBar: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                onPressed: () {
                  router.goNamed(homePageRoute);
                },
                icon: const Icon(Icons.arrow_back_rounded),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
          image:
              'https://image.tmdb.org/t/p/original${movieDetails['backdrop_path'].toString()}',
          expandedBody: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.background,
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => Icon(
                Icons.error_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 50,
              ),
              fadeInDuration: const Duration(milliseconds: 250),
              fadeOutDuration: const Duration(milliseconds: 250),
              placeholderFadeInDuration: const Duration(milliseconds: 250),
              imageUrl:
                  'https://image.tmdb.org/t/p/original${movieDetails['poster_path']}',
              placeholder: (context, url) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              },
              fit: BoxFit.fitWidth,
            ),
          ),
          fullyStretchable: true,
          title: movieDetails['title'],
          body: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    movieDetails['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "\"${movieDetails['tagline'] ?? 'Oops! No tagline.'}\"",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Release Date',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                                DateTime.parse(movieDetails['release_date'])),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Runtime',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${movieDetails['runtime']} minutes',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Vote Average',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${movieDetails['vote_average']}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            "${movieDetails['vote_count']} votes",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                    ),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movieDetails['genres'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    movieDetails['genres'][index]['name']
                                        .toString(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: AdultOnly(
                              adult: movieDetails['adult'],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Popularity score: ${movieDetails['popularity']}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(movieDetails['overview']),
                  const SizedBox(height: 8),
                  movieDetails['belongs_to_collection'] != null
                      ? Text(
                          'Part of the ${movieDetails['belongs_to_collection']['name']} collection',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  movieDetails['belongs_to_collection'] != null
                      ? Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: MediaQuery.of(context).size.width,
                          child: SizedBox(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/original${movieDetails['belongs_to_collection']['backdrop_path']}',
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error_rounded,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      size: 50,
                                    ),
                                    fadeInDuration:
                                        const Duration(milliseconds: 250),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 250),
                                    placeholderFadeInDuration:
                                        const Duration(milliseconds: 250),
                                    placeholder: (context, url) {
                                      return Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      );
                                    },
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movieDetails['belongs_to_collection']['name'],
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 8),
                  Text(
                    'Production Companies',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: movieDetails['production_companies'].length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final company =
                            movieDetails['production_companies'][index];
                        if (company['logo_path'] != null) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFFFFFFF),
                            ),
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original${company['logo_path']}',
                                fadeInDuration:
                                    const Duration(milliseconds: 250),
                                fadeOutDuration:
                                    const Duration(milliseconds: 250),
                                placeholderFadeInDuration:
                                    const Duration(milliseconds: 250),
                                placeholder: (context, url) {
                                  return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 100,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    company['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Languages in the Movie',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ListView.builder(
                itemCount: movieDetails['spoken_languages'].length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final lang = movieDetails['spoken_languages'][index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${lang['english_name']} (${lang['name']})",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FutureBuilder(
              future: castFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: Text('Error'),
                    ),
                  );
                }
                final Map<String, dynamic> castDetails =
                    snapshot.data as Map<String, dynamic>;
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Cast',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: castDetails['cast'].length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final cast = castDetails['cast'][index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: FlipCard(
                                flipOnTouch: true,
                                direction: FlipDirection.HORIZONTAL,
                                side: CardSide.FRONT,
                                speed: 500,
                                front: Container(
                                  height: double.infinity,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original${cast['profile_path']}',
                                      errorWidget: (context, url, error) =>
                                          Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            cast['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.error_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 50,
                                          ),
                                        ],
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 250),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 250),
                                      placeholderFadeInDuration:
                                          const Duration(milliseconds: 250),
                                      placeholder: (context, url) {
                                        return Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                back: Container(
                                  height: double.infinity,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        cast['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'as ${cast['character']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }
}
