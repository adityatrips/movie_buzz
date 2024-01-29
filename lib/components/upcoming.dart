import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_buzz/components/smol/movie_card.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  late List<dynamic> nowPlaying = [];

  Future<void> _getPlayingNowMovies() async {
    final url = Uri.parse('https://api.themoviedb.org/3/movie/upcoming');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${dotenv.env['BEARER_TOKEN']}"
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nowPlaying.addAll(
          data['results'],
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPlayingNowMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nowPlaying.length > 5 ? 5 : nowPlaying.length,
              itemBuilder: (context, index) {
                final movie = nowPlaying[index];
                return MovieCard(
                  overview: movie['overview'],
                  voteAverage: movie['vote_average'],
                  voteCount: movie['vote_count'],
                  id: movie['id'],
                  adult: movie['adult'],
                  backdropPath: movie['poster_path'],
                  originalLanguage: movie['original_language'],
                  originalTitle: movie['original_title'],
                  video: movie['video'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
