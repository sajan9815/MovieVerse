import 'package:flutter/material.dart';
import 'movie_details_page.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allMovies;

  const SearchScreen({super.key, required this.allMovies});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<Map<String, dynamic>> _searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchResults = widget.allMovies;
  }

  void _searchMovies(String query) {
    setState(() {
      _searchResults = widget.allMovies.where((movie) {
        final title = movie['title'].toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search movie titles...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchMovies,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _searchMovies('');
            },
          ),
        ],
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('No movies found'))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final movie = _searchResults[index];
          return ListTile(
            leading: Image.network(
              movie['poster'],
              width: 50,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.movie),
            ),
            title: Text(movie['title']),

            subtitle: Text('${movie['year']} • Rating: ${movie['rating']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsPage(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}