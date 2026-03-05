import 'package:flutter/material.dart';
import 'package:pilem/services/api_services.dart';
import 'package:pilem/models/movie.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData = await _apiService.getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData = await _apiService.getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData = await _apiService.getPopularMovies();

  setState(() {
    _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
    _trendingMovies = trendingMoviesData.map((e) => Movie.fromJson(e)).toList();
    _popularMovies = popularMoviesData.map((e) => Movie.fromJson(e)).toList();
  });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilem'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieList("All Movies", _allMovies),
            _buildMovieList("Trending Movies", _trendingMovies),
            _buildMovieList("Popular Movies", _popularMovies),

          ],
        ),
      ),
    );
  }
  Widget _buildMovieList(String title, List<Movie> movies){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(8.0),
        child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index){
            final movie = movies[index];
            return Container(
              width: 120,
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network("https://image.tmdb.org/t/p/w500${movie.posterPath}", fit: BoxFit.cover,),
                  SizedBox(height: 8.0,),
                  Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                ],
              ),
            );
           }
        )
        ),
      ],
    );
  }
}