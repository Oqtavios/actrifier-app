import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

import '../data.dart';
import '../uiparts.dart';
import '../actors_view.dart';


class ActorListItem extends StatefulWidget {
  final Actor actor;
  final bool dismissable;
  final bool initiallyExpanded;

  const ActorListItem(this.actor, {Key? key, this.dismissable = false, this.initiallyExpanded = false}) : super(key: key);

  @override
  _ActorListItemState createState() => _ActorListItemState();
}

class _ActorListItemState extends State<ActorListItem> with TickerProviderStateMixin{
  bool visible = true;
  bool buttonLoading = false;
  bool expanded = false;

  bool get isExpandable => true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: visible ? Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.only(bottom: expanded ? 0 : 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor
              ),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: CircleAvatar(
                      foregroundImage: widget.actor.image != null ? NetworkToFileImage(
                        url: widget.actor.image!,
                        file: File(App.of(context).imageCachePath + widget.actor.image!.split('/').last),
                      ) : null,
                      backgroundColor: Theme.of(context).bottomAppBarColor,
                      child: Icon(Icons.person_outline),
                    ),
                    title: Text(
                      widget.actor.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.actor.description ?? 'No description',
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        isExpandable ? SizedBox(
                          height: 18,
                          width: 18,
                          child: ExpandIcon(
                            onPressed: (_) => setState(() {
                              expanded = !expanded;
                            }),
                            padding: EdgeInsets.zero,
                            size: 18,
                            isExpanded: expanded,
                          ),
                        ) : Container(),
                      ],
                    ),
                    contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8),
                    trailing: SizedBox(
                      width: 94,
                      child: buttonLoading ? Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator())) : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: widget.actor.following ? Colors.transparent : Theme.of(context).accentColor,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(360),
                            side: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 0.8,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12)
                        ),
                        label: Text(
                          widget.actor.following ? 'Unfollow' : 'Follow',
                          style: Theme.of(context).textTheme.button!.copyWith(color: widget.actor.following ? Theme.of(context).accentColor : Theme.of(context).primaryColor, fontSize: 11.5),
                        ),
                        icon: Icon(widget.actor.following ? Icons.person_remove_outlined : Icons.person_add_outlined, color: widget.actor.following ? Theme.of(context).accentColor : Theme.of(context).primaryColor, size: 15),
                        onPressed: () async {
                          setState(() {
                            buttonLoading = true;
                          });
                          try {
                            if (widget.actor.following) {
                              await App.of(context).removeSubscription(widget.actor);

                              setState(() {
                                if (widget.dismissable) {
                                  visible = false;
                                }
                              });

                              if (App.of(context).subscriptions.isEmpty) {
                                ActorsView.of(context)!.setState(() {});
                              }
                            } else {
                              await App.of(context).addSubscription(widget.actor);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Hurray! From now on you will be notified about new ${widget.actor.name}'s movies"),
                              ));
                            }
                          } on WrongRequestError {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sorry, you are not following this actor')));
                          } catch (e) {
                            print('error: ${e.toString()}');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unknown error occurred, check your connection and try again')));
                          }
                          setState(() {
                            buttonLoading = false;
                          });
                        },
                      ),
                    ),
                    onTap: isExpandable ? () => setState(() {
                      expanded = !expanded;
                    }) : null,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: expanded ? Center(
                      child: Column(
                        children: [
                          AnimatedSize(
                            vsync: this,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linearToEaseOut,
                            child: FutureBuilder<FullActor>(
                              future: () async {
                                return await App.of(context).getActorInfo(widget.actor);
                              }(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print('err is ${snapshot.error!}');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: SmallErrorhintDisplay(
                                      largeText: snapshot.error is WrongRequestError ? 'Actor info not found' : 'Uh-oh.. Something went wrong',
                                      icon: Icons.error_outline_outlined,
                                      smallText: snapshot is WrongRequestError ? null : 'Try checking your connection',
                                    ),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 6, right: 6, top: 7),
                                    child: Center(
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        minHeight: 1,
                                      ),
                                    ),
                                  );
                                }
                                return ExpandedActorInfo(snapshot.data!);
                              }
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ) : SizedBox(height: 0),
    );
  }
}
