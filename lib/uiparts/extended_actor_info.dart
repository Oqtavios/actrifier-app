import 'dart:math' show min;

import 'package:flutter/material.dart';

import 'movie_tile.dart';
import '../data.dart';

class ExpandedActorInfo extends StatefulWidget {
  final FullActor actor;

  const ExpandedActorInfo(this.actor, {Key? key}) : super(key: key);

  @override
  _ExpandedActorInfoState createState() => _ExpandedActorInfoState();
}

class _ExpandedActorInfoState extends State<ExpandedActorInfo> {
  bool fullyExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: widget.actor.birthYear == null && widget.actor.deathYear == null && widget.actor.age == null ? SizedBox(height: 0) : RichText(
            text: TextSpan(
              text: widget.actor.birthYear != null ? 'Born ' : '',
              children: [
                TextSpan(
                  text: widget.actor.birthYear != null ? '${widget.actor.birthYear} ' : '',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.actor.age != null ? '(age ' : '',
                ),
                TextSpan(
                  text: widget.actor.age != null ? '${widget.actor.age}) ' : '',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: widget.actor.deathYear != null ? 'died ' : '',
                ),
                TextSpan(
                  text: widget.actor.deathYear != null ? '${widget.actor.deathYear}' : '',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          subtitle: widget.actor.description != null ? Text(widget.actor.description!.trim()) : null,
        ),
        widget.actor.movies!.isNotEmpty ? GridView.builder(
          shrinkWrap: true,
          itemCount: fullyExpanded ? widget.actor.movies!.length : min(4, widget.actor.movies!.length),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            var movie = widget.actor.movies![i];
            return MovieTile(movie);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              mainAxisExtent: 60
          ),
        ) : SizedBox(height: 0),
        widget.actor.movies!.length > 4 ? TextButton.icon(
          style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 8)),
              overlayColor: MaterialStateProperty.all(Colors.transparent)
          ),
          label: Text(
            fullyExpanded ? 'Less titles' : 'All ${widget.actor.movies!.length} titles',
            style: Theme.of(context).textTheme.caption,
          ),
          icon: SizedBox(
            height: 20,
            width: 20,
            child: ExpandIcon(
              size: 20,
              padding: EdgeInsets.zero,
              isExpanded: fullyExpanded,
              onPressed: (_) => setState(() => fullyExpanded = !fullyExpanded),
            ),
          ),
          onPressed: () => setState(() => fullyExpanded = !fullyExpanded),
        ) : Container(
          margin: EdgeInsets.only(bottom: 8),
        ),
      ],
    );
  }
}