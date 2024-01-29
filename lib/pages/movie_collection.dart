import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_buzz/components/smol/draggable_home_wrapper.dart';
import 'package:movie_buzz/components/smol/movie_card.dart';

class MovieCollections extends StatefulWidget {
  const MovieCollections({super.key, required this.collectionId});

  final String collectionId;

  @override
  State<MovieCollections> createState() => _MovieCollectionsState();
}

class _MovieCollectionsState extends State<MovieCollections> {
  late Future<void> collectionFuture;
  String name = '';

  Future<List<dynamic>> _getCollection() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/collection/${widget.collectionId}');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${dotenv.env['BEARER_TOKEN']}"
      },
    );

    setState(() {
      name = json.decode(response.body)['name'].toString();
    });

    return json.decode(response.body)['parts'] as List<dynamic>;
  }

  @override
  void initState() {
    super.initState();
    collectionFuture = _getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHomeWrapper(
      headerBottomBar: [],
      title: name,
      fullyStretchable: false,
      expandedBody: Container(),
      body: [
        FutureBuilder(
          future: collectionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            final collection = snapshot.data as List<dynamic>;

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width - 20,
              child: ListView.builder(
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: MovieCard(
                      voteCount: collection[index]['vote_count'] as int,
                      video: collection[index]['video'] as bool,
                      voteAverage: collection[index]['vote_average'] as double,
                      overview: collection[index]['overview'].toString(),
                      originalLanguage:
                          collection[index]['original_language'].toString(),
                      originalTitle:
                          collection[index]['original_title'].toString(),
                      backdropPath:
                          collection[index]['backdrop_path'].toString(),
                      adult: collection[index]['adult'] as bool,
                      id: collection[index]['id'] as int,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
      image: '',
    );
  }
}
