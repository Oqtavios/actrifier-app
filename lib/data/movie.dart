//import 'actor.dart';

class Movie {
  final String title;
  final int? year;
  final String? role;

  Movie({required this.title, this.year, this.role});

  factory Movie.fromJson(Map<String,dynamic> json) => Movie(
    title: json['title'],
    year: json['year'],
    role: json['role'],
  );

  factory Movie.fromServerJson(Map<String,dynamic> json) => Movie(
    title: json['title'],
    year: json['year'] != null ? int.tryParse(json['year']) : null,
    role: json['role'],
    //cast: json['actors'].map((actor) => Actor(id: 'not necessary', name: actor)).toList().cast<Actor>(),
  );
}