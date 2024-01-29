import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_buzz/components/smol/movie_card.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Uri getApiUri(String query, [bool adult = false]) {
    query = query.replaceAll(' ', '%20');
    return Uri.parse(
      'https://api.themoviedb.org/3/search/movie?query=$query&include_adult=$adult',
    );
  }

  final TextEditingController _searchController = TextEditingController(
    text: '',
  );

  Future<Map<String, dynamic>> searchFuture = Future.value({});

  Future<Map<String, dynamic>> _getSearchResults() async {
    final response = await http.get(
      getApiUri(
        _searchController.text,
        true,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${dotenv.env['BEARER_TOKEN']}"
      },
    );

    final data = await json.decode(response.body);
    return data as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    searchFuture = _getSearchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Discover Movies",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a movie',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              searchFuture = _getSearchResults();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            fixedSize: Size(
              MediaQuery.of(context).size.width - 20,
              MediaQuery.of(context).size.height * 0.05,
            ),
          ),
          child: Text(
            'Search',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        FutureBuilder(
          future: searchFuture,
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

            final data = snapshot.data as Map<String, dynamic>;

            if ((data['results'] as List).isEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.7,
                child: const Center(
                  child: Text('Try searching for a movie!'),
                ),
              );
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 11 / 16,
                ),
                itemCount: snapshot.data!['results'].length,
                itemBuilder: (context, index) {
                  final mov = snapshot.data!['results'][index];

                  return MovieCard(
                    overview: mov['overview'].toString(),
                    voteAverage: mov['vote_average'],
                    voteCount: mov['vote_count'],
                    id: mov['id'] as int,
                    adult: mov['adult'] as bool,
                    backdropPath: mov['poster_path'].toString(),
                    originalLanguage: mov['original_language'].toString(),
                    originalTitle: mov['original_title'].toString(),
                    video: mov['video'] as bool,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
