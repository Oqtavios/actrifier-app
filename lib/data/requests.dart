import 'dart:convert';

import 'package:http/http.dart' as http;

import 'example.dart';

class Response {
  final int code;
  dynamic? data;

  Response({required this.code, this.data});
}

class Requests {
  final String? firebaseToken;
  final String _server = 'https://actrifier.itsleo.cc/api/v1';
  bool example;

  Requests({required this.firebaseToken, this.example = false});

  Future<Response> addSubscription({required String actorId}) async {
    if (example) {
      return Response(code: await exampleSubscribeCode());
    }

    var uri = Uri.parse(_server + '/subscription?firebaseToken=$firebaseToken&id=$actorId');
    var serverResponse = await http.put(uri);
    return Response(code: serverResponse.statusCode);
  }

  Future<Response> removeSubscription({required String actorId}) async {
    if (example) {
      return Response(code: await exampleUnsubscribeCode());
    }

    var uri = Uri.parse(_server + '/subscription?firebaseToken=$firebaseToken&id=$actorId');
    var serverResponse = await http.delete(uri);
    return Response(code: serverResponse.statusCode);
  }

  Future<Response> search({String? query, bool feelingLucky = false}) async {
    if (!feelingLucky && (query == null || (query != null && query.isEmpty))) {
      throw ArgumentError.notNull('query');
    }

    if (example) {
      return Response(
        code: await exampleSearchCode(),
        data: exampleActors..shuffle(),
      );
    }

    var feelingLuckyInt = feelingLucky ? 1 : 0;

    var uri = Uri.parse(_server + '/search?name=$query&feelingLucky=$feelingLuckyInt');
    var serverResponse = await http.get(uri);
    return Response(code: serverResponse.statusCode, data: serverResponse.statusCode < 400 ? jsonDecode(serverResponse.body) : null);
  }

  Future<Response> fullActorInfo({required String actorId}) async {
    if (example) {
      return Response(
        code: await exampleSearchCode(),
        data: exampleActorInfo,
      );
    }

    var uri = Uri.parse(_server + '/actor?id=$actorId');
    var serverResponse = await http.get(uri);
    return Response(code: serverResponse.statusCode, data: serverResponse.statusCode < 400 ? jsonDecode(serverResponse.body) : null);
  }
}