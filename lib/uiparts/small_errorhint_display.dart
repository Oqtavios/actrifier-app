import 'package:flutter/material.dart';

class SmallErrorhintDisplay extends StatelessWidget {
  final String largeText;
  final String? smallText;
  final IconData icon;

  const SmallErrorhintDisplay({Key? key, required this.largeText, required this.icon, this.smallText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
        leading: Icon(icon, color: Theme.of(context).accentColor, size: 28),
        title: Text(
          largeText,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
            color: Theme.of(context).textTheme.caption!.color,
          ),
        ),
        subtitle: smallText != null ? Text(
          smallText!,
          style: Theme.of(context).textTheme.caption!.copyWith(
            color: Theme.of(context).accentColor,
          ),
        ) : null,
      ),
    );
  }
}
