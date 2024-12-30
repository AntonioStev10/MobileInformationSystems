import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class FavoriteJokesScreen extends StatefulWidget {
  final List<Joke> favoriteJokes;
  final Function(Joke) onRemoveFromFavorites;

  const FavoriteJokesScreen({
    Key? key,
    required this.favoriteJokes,
    required this.onRemoveFromFavorites
  }) : super(key: key);

  @override
  _FavoriteJokesScreenState createState() => _FavoriteJokesScreenState();
}

class _FavoriteJokesScreenState extends State<FavoriteJokesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jokes'),
        backgroundColor: Colors.amber,
      ),
      body: widget.favoriteJokes.isEmpty
          ? Center(child: Text('No favorite jokes yet!'))
          : ListView.builder(
        itemCount: widget.favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = widget.favoriteJokes[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(joke.setup),
              subtitle: Text(joke.punchline),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.onRemoveFromFavorites(joke);
                  setState(() {});
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
