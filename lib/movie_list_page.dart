import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'movie_category.dart';
import 'movie_details_page.dart';
import 'search_screen.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<Map<String, dynamic>>> _allMoviesFuture;

  @override
  void initState() {
    super.initState();
    _allMoviesFuture = _loadAllMovies();
  }

  Future<List<Map<String, dynamic>>> _loadAllMovies() async {
    final jsonFiles = [
      'assets/dc_movies.json',
      'assets/marvel_movies.json',
      'assets/moviee.json',
      'assets/nepali_movies.json',
      'assets/top_picks.json',
      'assets/top_rated_movies.json',
      'assets/trending_movies.json',
    ];

    List<Map<String, dynamic>> allMovies = [];

    for (var file in jsonFiles) {
      try {
        final jsonString = await rootBundle.loadString(file);
        final movies = json.decode(jsonString) as List;
        allMovies.addAll(movies.cast<Map<String, dynamic>>());
      } catch (e) {
        debugPrint('Error loading $file: $e');
      }
    }

    return allMovies;
  }

  void _navigateToSearch(BuildContext context) async {
    final allMovies = await _allMoviesFuture;
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(allMovies: allMovies),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieVerse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _navigateToSearch(context),
          ),
        ],
      ),
      body: ListView(
        children: const [
          MovieCategory(
            title: 'Developer Top Picks',
            assetPath: 'assets/top_picks.json',
          ),
          MovieCategory(
            title: 'Marvel Cinematic Universe',
            assetPath: 'assets/marvel_movies.json',
          ),
          MovieCategory(
            title: 'DC Extended Universe',
            assetPath: 'assets/dc_movies.json',
          ),
          MovieCategory(
            title: 'Top Rated Movies',
            assetPath: 'assets/top_rated_movies.json',
          ),
          MovieCategory(
            title: 'Horror Movies',
            assetPath: 'assets/nepali_movies.json',
          ),
          MovieCategory(
            title: 'Recommended',
            assetPath: 'assets/moviee.json',
          ),
        ],
      ),
    );
  }
}