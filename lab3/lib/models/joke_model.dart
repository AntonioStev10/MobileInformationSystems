class Joke {
  String setup;
  String punchline;
  bool isFavorite;

  Joke(this.setup, this.punchline, {this.isFavorite = false});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      json['setup'] ?? 'No setup provided',
      json['punchline'] ?? 'No punchline provided',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
      'isFavorite': isFavorite,
    };
  }

  String getSummary() {
    return '$setup - $punchline';
  }

  @override
  String toString() {
    return 'Joke: $setup\nPunchline: $punchline';
  }
}
