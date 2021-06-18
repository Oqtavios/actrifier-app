List<dynamic> exampleFilms = [
  {
    'title': 'Hello darkness',
    'year': 2038,
    'actors': [
      'My old friend',
      'Your cousin',
    ],
  },
  {
    'title': 'Logan',
    'year': 2017,
    'actors': [
      'Chloride Manide',
      'Banana Peal',
    ],
  },
  {
    'title': 'Schweppes lime mojito',
    'year': 1987,
    'actors': [
      'My old friend',
    ],
  },
  {
    'title': 'X-People',
    'year': 2004,
    'actors': [
      'Mouse Wheel',
      'Selector #2',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
  {
    'title': 'Stax',
    'year': 2014,
    'actors': [
      'Moustache Man',
      'Feather Soap',
    ],
  },
];

Map<String,dynamic> exampleActorInfo = {
  'id': 'hugh',
  'name': 'Hugh Jackman',
  'photo': 'https://m.media-amazon.com/images/M/MV5BNDExMzIzNjk3Nl5BMl5BanBnXkFtZTcwOTE4NDU5OA@@._V1_.jpg',
  'description': 'Hugh Michael Jackman is an Australian actor, singer, multi-instrumentalist, dancer and producer. Jackman has won international recognition for his roles in major films, notably as superhero, period, and romance characters. He is best known for his long-running role as Wolverine in the X-Men film series, as well as for his lead roles in the...',
  'birth_info': ['December 21', '1993', 'Hollywood, CA'],
  //'death_info': ['December 21', '2057', 'Hollywood, CA'],
  'age': 28,
  'movie_count': 61,
  'movies': exampleFilms,
};

List<dynamic> exampleActors = [
  {
    'id': 'hugh',
    'name': 'Hugh Jackman',
    'photo': 'https://m.media-amazon.com/images/M/MV5BNDExMzIzNjk3Nl5BMl5BanBnXkFtZTcwOTE4NDU5OA@@._V1_.jpg',
    'description': 'Logan, Prestige',
    //'films': exampleFilms,
  },
  {
    'id': 'jane',
    'name': 'Jane C. Levy',
    'photo': 'https://m.media-amazon.com/images/M/MV5BM2FlOGZlMTMtMmY2ZS00MTgwLWI2ZjktYjRlNGQ4OTY3MmZjXkEyXkFqcGdeQXVyMjM2MTM1ODA@._V1_.jpg',
    'description': "Zoey's Extraordinary Playlist",
  },
  {
    'id': 'mackenzie',
    'name': 'Mackenzie Davis',
    'photo': 'https://m.media-amazon.com/images/M/MV5BYzRkYmE0YWYtY2I3OC00OTAyLWE5YmItYzIwMGYyMTk1NDk3XkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_.jpg',
    'description': 'Halt and Catch Fire, Black Mirror',
    //'films': exampleFilms
  },
  {
    'id': 'ben',
    'name': 'Ben Platt',
    'photo': 'https://m.media-amazon.com/images/M/MV5BMjQ0NjUwMTYwNF5BMl5BanBnXkFtZTgwMDg4MTMwNTM@._V1_.jpg',
    'description': 'The Politician, Dear Evan Hansen',
  },
  {
    'id': 'fran',
    'name': 'Fran Drescher',
    'photo': 'https://m.media-amazon.com/images/M/MV5BY2I4YWExZjEtNTJjYi00Y2IzLThkMDMtYWIxZGNmZmZmMmU4XkEyXkFqcGdeQXVyNTU5ODYzOTY@._V1_.jpg',
    'description': 'The Nanny',
  },
];

/*{
          'id': '',
          'name': '',
          'imageURL': '',
          'description': '',
          'films': [
            {
              'title': '',
              'year': 0,
              'posterURL': '',
              'actors': [
                {
                  'id': '',
                  'name': '',
                },
                {
                  'id': '',
                  'name': '',
                },
              ],
            },
          ],
        }
*/

Future<int> exampleSearchCode () async {
  await Future.delayed(Duration(milliseconds: 500));
  var results = [200, 200, 200, 200, 200, 200, 200, 200, 404, 503, 200, 200, 200, 200, 200, 200, 200, 200, 200]..shuffle();
  return results.first;
}

Future<int> exampleSubscribeCode () async {
  await Future.delayed(Duration(milliseconds: 500));
  var results = [201, 404, 503, 201, 201, 201, 201, 201]..shuffle();
  return results.first;
}

Future<int> exampleUnsubscribeCode () async {
  await Future.delayed(Duration(milliseconds: 500));
  var results = [200, 404, 503, 200, 200, 200, 200, 200, 200]..shuffle();
  return results.first;
}