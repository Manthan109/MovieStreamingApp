import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseURL = "https://api.themoviedb.org/3/movie/";
const baseImageUrl = "https://image.tmdb.org/t/p/";
const apiKey = "871c88f99d3f5c59bccbafc052cfc67d";
//const api_key="<API_KEY>";
const now_playingURL = "${baseURL}now_playing?api_key=$apiKey";
const upcomingURL = "${baseURL}upcoming?api_key=$apiKey";
const popularURL = "${baseURL}popular?api_key=$apiKey";
const topRatedURL = "${baseURL}top_rated?api_key=$apiKey";

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    title: "My Movie App",
    home: MyMovieApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieAppState createState() => _MyMovieAppState();
}

class _MyMovieAppState extends State<MyMovieApp> {
  Movie nowPlayingMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(now_playingURL);
    var decodeJSON = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJSON);
      print(decodeJSON);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(upcomingURL);
    var decodeJSON = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJSON);
      print(decodeJSON);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularURL);
    var decodeJSON = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJSON);
      print(decodeJSON);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(topRatedURL);
    var decodeJSON = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJSON);
      print(decodeJSON);
    });
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider(
      items: nowPlayingMovies == null
          ? <Widget>[
        Center(
          child: CircularProgressIndicator(),
        )
      ]
          : nowPlayingMovies.results
          .map((movieItem) =>
          Image.network('${baseImageUrl}w342${movieItem.posterPath}'))
          .toList(),
      autoPlay: false,
      height: 240.0,
      viewportFraction: 0.5,
    );
  }

  Widget _buildMoviesListItem(Results movieItem) {
    Material(
      child: Container(
        width: 128.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(6.0),
              child:,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.0, top: 2.0),
              child: Text(movieItem.title, style: TextStyle(

              ),),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesListView(Movie movie, String movieListTitle) {
    return Container(
      height: 258.0,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
            child: Text(
              movieListTitle,
              style: TextStyle(fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400]),
            ),
          ),
          Flexible(
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: movie == null ? <Widget>[
                  CircularProgressIndicator(),
                ] : movie.results.map((movieItem) =>
                    Padding(
                      padding: EdgeInsets.only(left: 6.0, right: 2.0),
                      child:,
                    ))
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Movies",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "NOW PLAYING",
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0),
                    ),
                  ),
                ),
                expandedHeight: 290.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          '${baseImageUrl}w500//mbm8k3GFhXS0ROd9AD1gqYbIFbM.jpg',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.dstATop,
                          width: 1000.0,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _buildCarouselSlider(),
                      )
                    ],
                  ),
                ),
              )
            ];
          },
          body: Text("Scroll me ")),
    );
  }
}
