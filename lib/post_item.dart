import 'package:flutter/material.dart';
import 'package:isolates_test/post.dart';

class PostItem extends StatelessWidget {
  PostItem({this.post});
  final Post post;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            top: 10.0,
            right: 15.0
          ),
          child: Text(post.title),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 5.0,
            left: 15.0,
            right: 15.0,
            bottom: 5.0
          ),
          child: Text(post.body),
        )
      ],
    );
  }
}