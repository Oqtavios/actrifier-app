import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'data.dart';
import 'uiparts.dart';

class ActorsView extends StatefulWidget {
  ActorsView({Key? key}) : super(key: key);

  @override
  _ActorsViewState createState() => _ActorsViewState();

  static _ActorsViewState? of(BuildContext context) => context.findAncestorStateOfType<_ActorsViewState>();
}

class _ActorsViewState extends State<ActorsView> {
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool feelingLucky = false;

  bool _searching = false;
  bool get isSearching => _searching || App.of(context).instantSearch && searchController.text.isNotEmpty;
  set isSearching (bool value) => _searching = value;

  _ActorsViewState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      App.of(context).onForegroundNotification = (event) {
        if (event.notification != null && event.notification!.title != null || event.notification!.body != null) {
          showDialog(
            context: context,
            builder: (context) => NotificationCard(event.notification!),
            barrierColor: Colors.black54.withOpacity(0.3),
          );
        }
      };
    });
  }

  void unfocusSearchBar() async {
      searchFocusNode.unfocus();
      searchFocusNode.canRequestFocus = false;
      Future.delayed(Duration(milliseconds: 100), () => searchFocusNode.canRequestFocus = true);
    }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => searchFocusNode.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (isSearching) {
            searchController.clear();
            searchFocusNode.unfocus();
            isSearching = false;
            setState(() {});
            return false;
          }
          return true;
        },
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: SafeArea(
              child: AppBar(
                elevation: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    onChanged: (_) {
                      if (App.of(context).instantSearch || !isSearching) {
                        setState(() {});
                      }
                    },
                    onEditingComplete: () => setState(() {
                      isSearching = true;
                      searchFocusNode.unfocus();
                    }),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(18),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                      hintText: 'Search for actors',
                      prefixIcon: searchController.text.isEmpty ? IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.search_outlined),
                        onPressed: () {
                          searchController.text = "I'm feeling lucky";
                          feelingLucky = true;
                          unfocusSearchBar();
                          isSearching = true;
                          setState(() {});
                        },
                      ) : IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          searchController.clear();
                          unfocusSearchBar();
                          isSearching = false;
                          setState(() {});
                        },
                      ),
                      suffixIcon: searchController.text.isNotEmpty ? IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.search_outlined),
                        onPressed: () async {
                          unfocusSearchBar();
                          setState(() => isSearching = true);
                        },
                      ) : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Hero(tag: 'settings', child: Icon(Icons.settings_outlined)),
                          color: Theme.of(context).primaryColorLight,
                          onPressed: () {
                            unfocusSearchBar();

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.6),
                                pageBuilder: (context, _, __) => SettingsDialog(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: !isSearching ? App.of(context).subscriptions.isEmpty ? LargeErrorhintDisplay(
              icon: Icons.people_outline,
              largeText: "You're not following any actors",
              smallText: 'Search for your favorite actors and follow them to get notifications about their upcoming movies',
            ) : ListView.builder(
              physics: BouncingScrollPhysics(),
              cacheExtent: 16384,
              itemCount: App.of(context).subscriptions.length + 1,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, bottom: 8),
                    child: Text(
                      'FOLLOWING',
                      style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  try {
                    return ActorListItem(App
                        .of(context)
                        .subscriptions[i - 1], dismissable: true);
                  } on RangeError {
                    debugPrint("Some items were deleted, but widget tree and item count haven't been updated yet");
                    return Container();
                  }
                }
              },
            ) : FutureBuilder<dynamic>(
              future: () async {
                var response = await App.of(context).search(query: searchController.text, feelingLucky: feelingLucky);
                if (feelingLucky && response.isNotEmpty) {
                  feelingLucky = false;
                  searchController.text = response.first.name;
                }
                return response;
              }(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error!.toString());
                  if (snapshot.error! is WrongRequestError) {
                    return LargeErrorhintDisplay(
                      icon: Icons.person_search_outlined,
                      largeText: "Actor you're looking for wasn't found",
                      smallText: 'Check their name spelling and try again',
                    );
                  } else {
                    return LargeErrorhintDisplay(
                      icon: Icons.search_off_outlined,
                      largeText: 'Search failed',
                      smallText: 'Check your connection or retry later',
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  var searchResults = snapshot.data;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    cacheExtent: 16384,
                    itemCount: searchResults!.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 8),
                          child: Text(
                            'SEARCH RESULTS',
                            style: Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        if (App.of(context).subscriptions.where((actor) => actor.id == searchResults[i - 1].id).isNotEmpty) {
                          searchResults[i - 1].following = true;
                        }
                        return ActorListItem(searchResults[i - 1], initiallyExpanded: i == 1);
                      }
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 64,
            child: Material(
              color: Theme.of(context).bottomAppBarColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              elevation: 20,
              child: Center(
                child: Text(
                  'Actrifier',
                  style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0, fontSize: 26),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}