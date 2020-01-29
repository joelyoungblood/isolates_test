import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:isolates_test/post.dart';
import 'package:isolate/isolate.dart';

final _request_url = "https://jsonplaceholder.typicode.com/posts";

Map<String, String> _headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
};

class Request {
  Future<List<Post>> fetchPostCompute() async {
    return compute(_fetchPosts, _request_url);
  }

  Future<List<Post>> fetchPostsIsolate() async {
    final isolate = await IsolateRunner.spawn();
    return isolate.run(_fetchPosts, _request_url).whenComplete((){
      isolate.close();
    });
  }
}

Future<List<Post>> _fetchPosts(String requestUrl) async {
  var client = Client();
  var result = await client.get(requestUrl);
  if (result.statusCode == 200) {
    final parse = json.decode(result.body).cast<Map<String, dynamic>>();
    client.close();
    return parse.map<Post>((json) => Post.fromJson(json)).toList();
  }
}