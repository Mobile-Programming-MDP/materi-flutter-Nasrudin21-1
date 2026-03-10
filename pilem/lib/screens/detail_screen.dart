import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  Future<void> _checkIfFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];

    setState(() {
      isFavorite = favoriteMovies.contains(widget.movie.toJsonString());
    });
  }

  Future<void> _toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteMovies = prefs.getStringList('favoriteMovies') ?? [];

    final movieJson = widget.movie.toJsonString();

    setState(() {
      if (favoriteMovies.contains(movieJson)) {
        favoriteMovies.remove(movieJson);
        isFavorite = false;
      } else {
        favoriteMovies.add(movieJson);
        isFavorite = true;
      }
    });

    await prefs.setStringList('favoriteMovies', favoriteMovies);
  }

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Overview',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(widget.movie.overview),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Release Date',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.releaseDate),
                ],
              ),
               const SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _toggleFavorite();
                    }, 
                  icon: Icon(
                      isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  )
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Rating:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.voteAverage.toString()),
                ],
              ),
            ],
          ),
        ),
      )
      );
  }
}