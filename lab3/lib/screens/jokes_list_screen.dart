import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke_model.dart';

class JokesListScreen extends StatefulWidget {
  final String type;
  final Function(Joke) onAddToFavorites;

  const JokesListScreen({required this.type, required this.onAddToFavorites, Key? key}) : super(key: key);

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.type} Jokes',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchJokesByType(widget.type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No jokes found!',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(
                height: 20,
                thickness: 2,
                color: Colors.amber,
              ),
              itemBuilder: (context, index) {
                final joke = Joke.fromJson(snapshot.data![index]);
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.amberAccent,
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    joke.setup,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      joke.punchline,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: joke.isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            joke.isFavorite = !joke.isFavorite;
                            if (joke.isFavorite) {
                              widget.onAddToFavorites(joke);
                            }
                          });
                        },
                      ),
                      const Icon(Icons.emoji_events_rounded, color: Colors.white),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'No jokes available at the moment.',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
