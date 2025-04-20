import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsPage({super.key, required this.movie});

  Future<void> _launchTrailer() async {
    final url = Uri.parse(movie['trailer']);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie['poster'],
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 100),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetadataItem(Icons.star, "${movie['rating']}"),
                _buildMetadataItem(Icons.calendar_today, "${movie['year']}"),
                _buildMetadataItem(Icons.timer, movie['duration']),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              movie['description'],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Crew"),
            _buildCrewItem("Director", movie['director']),
            _buildCrewItem("Producer", movie['producer']),
            _buildCrewItem("Writer", movie['writer']),
            const SizedBox(height: 20),
            _buildSectionTitle("Cast"),
            if (movie['cast']['actors'].isNotEmpty)
              _buildCrewItem("Actors", movie['cast']['actors'].join(", ")),
            if (movie['cast']['actresses'].isNotEmpty)
              _buildCrewItem("Actresses", movie['cast']['actresses'].join(", ")),
            const SizedBox(height: 20),
            _buildSectionTitle("Genres"),
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(
                movie['genres'].length,
                    (index) => Chip(
                  label: Text(movie['genres'][index]),
                  backgroundColor: Colors.deepPurple[200],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Watch Trailer"),
                onPressed: _launchTrailer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }

  Widget _buildCrewItem(String role, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          children: [
            TextSpan(
              text: "$role: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: name),
          ],
        ),
      ),
    );
  }
}