import 'package:firebase_messaging/firebase_messaging.dart' show RemoteNotification;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NotificationCard extends StatefulWidget {
  final RemoteNotification notification;

  const NotificationCard(this.notification, {Key? key}) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> with SingleTickerProviderStateMixin {
  bool visible = false;  // Used for appear animation

  _NotificationCardState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) => setState(() => visible = true));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 300),
        child: Offstage(
          offstage: !visible,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).snackBarTheme.backgroundColor!.withOpacity(0.9),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: Navigator.of(context).pop,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  foregroundImage: widget.notification.android != null && widget.notification.android!.imageUrl != null ? NetworkImage(
                    widget.notification.android!.imageUrl!,  // No matter which OS we're using, app can use any notification image
                  ) : null,
                  backgroundColor: Theme.of(context).bottomAppBarColor,
                  child: Icon(Icons.person_outline),
                ),
                title: Text(
                  widget.notification.title ?? widget.notification.body!,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).snackBarTheme.contentTextStyle!.color),
                ),
                subtitle: widget.notification.body != null ? Text(
                  widget.notification.body!,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).snackBarTheme.contentTextStyle!.color),
                ) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
