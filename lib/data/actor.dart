import 'movie.dart';

class Actor {
  final String id;
  final String name;
  final String? description;
  final String? image;
  bool following;
  //final List<Movie>? movies;

  Actor({required this.id, required this.name, this.description, this.image, this.following = false/*, this.movies*/});

  factory Actor.fromJson(Map<String,dynamic> json) => Actor(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    image: json['image'],
    following: json['following'] ?? false,
    //movies: json['movies']?.map((movie) => Movie.fromJson(movie)).toList().cast<Movie>() ?? [],
  );

  factory Actor.fromServerJson(Map<String,dynamic> json) => Actor(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    image: json['photo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'following': following,
  };
}

class FullActor extends Actor {
  final List<Movie>? movies;
  final int? age;
  final int? birthYear;
  final int? deathYear;

  FullActor({required id, required name, description, image, following = false, this.movies, this.age, this.birthYear, this.deathYear}) : super(
      id: id, name: name, description: description, image: image, following: following
  );

  static int? _extractYearFromInfo(dynamic info) {
    try {
      return int.parse(info.firstWhere((item) => int.tryParse(item) != null));
    } catch (_) {
      return null;
    }
  }

  factory FullActor.fromServerJson(Map<String,dynamic> json) => FullActor(
    id: json['id'],
    name: json['name'],
    description: json['bio'],
    image: json['photo'],
    age: json['age'],
    birthYear: _extractYearFromInfo(json['birth_info']),
    deathYear: _extractYearFromInfo(json['death_info']),
    movies: json['movies']?.map((movie) => Movie.fromServerJson(movie)).toList().cast<Movie>() ?? [],
  );
}