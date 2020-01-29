import 'package:flutter/material.dart';
import 'package:isolates_test/post.dart';
import 'package:isolates_test/test_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isolates_test/post_item.dart';

class TestPage extends StatefulWidget {
  TestPage(this.shouldUseCompute);
  final bool shouldUseCompute;

  @override
  _TestPageState createState() => _TestPageState(shouldUseCompute);
}

class _TestPageState extends State<TestPage> {
  _TestPageState(this.shouldUseCompute);
  final bool shouldUseCompute;
  
  final _bloc = TestBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(TestPageEventStartup(shouldUseCompute));
  }

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<TestBloc, TestPageState>(
        bloc: _bloc,
        builder: (BuildContext context, TestPageState state) {
          if (state is TestPageStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TestPageStateLoaded) {
            return _bodyForLoaded(state.posts);
          } else {
            return Center(child: Text('No idea chief'));
          }
        },
      );
  }

  Widget _bodyForLoaded(List<Post> posts) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: () {
          _bloc.add(TestPageEventStartup(shouldUseCompute));
          return Future.value();
        },
        child:  ListView.builder(
          itemCount: posts.length,
          itemBuilder: ((BuildContext context, int index) {
            return PostItem(post: posts[index]);
          }),
        ),
      )
    );
  }
}