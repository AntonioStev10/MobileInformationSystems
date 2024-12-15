import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'jokes_list_screen.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = apiService.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jokes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.casino, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.amber, Colors.amberAccent],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: jokeTypes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Oops! Something went wrong:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      tileColor: Colors.white54,
                      title: Text(
                        snapshot.data![index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward, color: Colors.teal),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JokesListScreen(type: snapshot.data![index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const Center(
              child: Text(
                'No joke types available.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          },
        ),
      ),
    );
  }
}
