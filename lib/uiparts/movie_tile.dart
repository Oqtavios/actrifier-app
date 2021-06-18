import 'package:flutter/material.dart';

import '../data.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;

  const MovieTile(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      isThreeLine: true,
      title: Text(
        movie.title,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 12),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            movie.year != null ? Text(
              movie.year.toString(),
              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
            ) : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                movie.role != null ? movie.role! : 'Role info not available',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 9),
              ),
            ),
          ],
        ),
      ),
      dense: true,
      minVerticalPadding: 14,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        child: Icon(Icons.movie_outlined, size: 20),
      ),
    );
  }
}