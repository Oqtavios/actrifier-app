import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../data.dart';

class _AppData {
  late final SharedPreferences preferences;
  late final FirebaseMessaging firebaseMessaging;
  late final Requests requests;
  late String imageCachePath;

  bool instantSearch = false;
  Function(RemoteMessage)? onForegroundNotification;
}

class App extends InheritedWidget {
  final _AppData _data = _AppData();

  App ({required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(App old) => old._data != _data;

  static App of(BuildContext context) {
    var ret = context.dependOnInheritedWidgetOfExactType<App>();
    // Null-safety thing
    if (ret == null) {
      throw Exception('of was called on null');
    } else {
      return ret;
    }
  }

  Future<String?> get firebaseToken async => await _data.firebaseMessaging.getToken();

  String get imageCachePath => _data.imageCachePath;

  bool get instantSearch => _data.instantSearch;
  set instantSearch (bool value) => _data.instantSearch = value;

  set onForegroundNotification (Function(RemoteMessage) func) => _data.onForegroundNotification = func;

  Future<void> initialize () async {
    _data.preferences = await SharedPreferences.getInstance();
    await Firebase.initializeApp();
    _data.firebaseMessaging = FirebaseMessaging.instance;
    await _data.firebaseMessaging.requestPermission();
    await _data.firebaseMessaging.setAutoInitEnabled(true);

    FirebaseMessaging.onMessage.listen((event) {
      if (_data.onForegroundNotification != null) {
        _data.onForegroundNotification!(event);
      } else {
        print("Foreground notification was received, but handler haven't been specified");
      }
    });

    _data.requests = Requests(firebaseToken: await _data.firebaseMessaging.getToken(), example: false);

    var tempDir = await getTemporaryDirectory();
    _data.imageCachePath = path.join(tempDir.path, 'image_cache') + '/';
    await Directory(_data.imageCachePath).create();

    if (!_data.preferences.containsKey('subscriptions')) {
      await _data.preferences.setStringList('subscriptions', []);
    }
  }

  Future<void> addSubscription(Actor actor) async {
    var subscriptions = _data.preferences.getStringList('subscriptions');

    // Check if we aren't subscribed
    if (subscriptions!.where((subscription) => jsonDecode(subscription)['id'] == actor.id).isEmpty) {
      var response = await _data.requests.addSubscription(actorId: actor.id);

      if (response.code != 201) {
        if (response.code == 404) {
          // ACTOR NOT FOUND (exception)
          throw RequestError();
        } else {
          // UNKNOWN ERROR (exception)
          throw Error();
        }
      }

      actor.following = true;
      if (subscriptions.isNotEmpty) {
        var i = 0;
        // Sorting when adding. Could be performance-efficient because we don't need to sort every time we look into subscriptions. An also much efficient than just sorting everything every element addition
        for (; i < subscriptions.length && actor.name.toLowerCase().compareTo(jsonDecode(subscriptions[i])['name'].toLowerCase()) > 0; i++) {}
        subscriptions.insert(i, jsonEncode(actor.toJson()));
      } else {
        subscriptions.add(jsonEncode(actor.toJson()));
      }

      await _data.preferences.setStringList('subscriptions', subscriptions);
    }
  }

  Future<void> removeSubscription(Actor actor) async {
    var response = await _data.requests.removeSubscription(actorId: actor.id);

    if (response.code != 200) {
      if (response.code == 404) {
        // ACTOR NOT FOUND (exception)
        throw WrongRequestError();
      } else {
        // UNKNOWN ERROR (exception)
        throw RequestError();
      }
    }

    var subscriptions = _data.preferences.getStringList('subscriptions');

    subscriptions!.removeWhere((subscription) => jsonDecode(subscription)['id'] == actor.id);
    actor.following = false;

    await _data.preferences.setStringList('subscriptions', subscriptions);
  }

  List<Actor> get subscriptions {
    var subscriptions = _data.preferences.getStringList('subscriptions');
    return subscriptions!.map((subscription) => Actor.fromJson(jsonDecode(subscription))).toList();
  }

  Future<List<Actor>> search({String? query, bool feelingLucky = false}) async {
    var response = await _data.requests.search(query: query, feelingLucky: feelingLucky);

    if (response.code != 200) {
      if (response.code == 404) {
        // ACTOR NOT FOUND (exception)
        throw WrongRequestError();
      } else {
        // UNKNOWN ERROR (exception)
        throw RequestError();
      }
    }

    return response.data['results'].map((actor) => Actor.fromServerJson(actor)).toList().cast<Actor>();
  }

  Future<FullActor> getActorInfo(Actor actor) async {
    var response = await _data.requests.fullActorInfo(actorId: actor.id);

    if (response.code != 200) {
      if (response.code == 400) {
        // ACTOR NOT FOUND (exception)
        throw WrongRequestError();
      } else {
        // UNKNOWN ERROR (exception)
        throw RequestError();
      }
    }

    return FullActor.fromServerJson(response.data['actor']);
  }
}
