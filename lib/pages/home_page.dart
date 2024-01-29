import 'package:flutter/material.dart';
import 'package:movie_buzz/components/playing_now.dart';
import 'package:movie_buzz/components/popular.dart';
import 'package:movie_buzz/components/top_rated.dart';
import 'package:movie_buzz/components/upcoming.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            child: Center(
              child: Text(
                "Movie Buzz",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Now playing",
            style: TextStyle(fontSize: 30),
          ),
          const NowPlaying(),
          const Text(
            "Top Rated",
            style: TextStyle(fontSize: 30),
          ),
          const TopRated(),
          const Text(
            "Popular",
            style: TextStyle(fontSize: 30),
          ),
          const Popular(),
          const Text(
            "Upcoming",
            style: TextStyle(fontSize: 30),
          ),
          const Upcoming(),
        ],
      ),
    );
  }
}
