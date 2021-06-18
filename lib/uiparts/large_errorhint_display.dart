import 'package:flutter/material.dart';

class LargeErrorhintDisplay extends StatelessWidget {
  final String largeText;
  final String? smallText;
  final IconData icon;
  final bool addBottomPadding;

  const LargeErrorhintDisplay({Key? key, required this.largeText, required this.icon, this.smallText, this.addBottomPadding = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 32, right: 32, bottom: addBottomPadding ? MediaQuery.of(context).size.height * 0.1 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 84, color: Theme.of(context).accentColor),
            Text(
              largeText,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            smallText != null ? Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                smallText!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
