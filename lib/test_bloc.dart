import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isolates_test/post.dart';
import 'package:isolates_test/request.dart';

//Events
abstract class TestPageEvent {}
class TestPageEventStartup extends TestPageEvent {
  TestPageEventStartup(this.shouldUseCompute);
  final bool shouldUseCompute;
}
class TestPageEventRefresh extends TestPageEvent {}

//States
abstract class TestPageState {}
class TestPageStateInitial extends TestPageState {}
class TestPageStateLoading extends TestPageState {}

class TestPageStateLoaded extends TestPageState {
  TestPageStateLoaded(this.posts);
  final List<Post> posts;
}

class TestPageStateError extends TestPageState {
  TestPageStateError(this.error);
  final String error;
}

class TestBloc extends Bloc<TestPageEvent, TestPageState> {
  @override
  TestPageState get initialState => TestPageStateInitial();

  final request = Request();

  @override
  Stream<TestPageState> mapEventToState(TestPageEvent event) async* {
    if (event is TestPageEventStartup) {
      yield TestPageStateLoading();
      try {
        if (event.shouldUseCompute) {
          var posts = await request.fetchPostCompute();
          yield TestPageStateLoaded(posts);
        } else {
          var posts = await request.fetchPostsIsolate();
          yield TestPageStateLoaded(posts);
        }
      } catch (e) {
        yield TestPageStateError(e.toString());
      }
    }
  }
}