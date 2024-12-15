class Joke {
  String setup;
  String punchline;

  Joke(this.setup, this.punchline);


  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      json['setup'] ?? 'No setup provided',
      json['punchline'] ?? 'No punchline provided',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
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
