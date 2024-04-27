import 'package:netxus/models/post_model.dart';

class User {
  final String profileImageUrl;
  final String backgroundImageUrl;
  final String name;
  final int following;
  final int followers;
  final List<Post> posts;
  final List<Post> favorites;

  User({
    this.profileImageUrl = '',
    this.backgroundImageUrl= '',
    this.name= '',
    this.following= 4,
    this.followers= 4,
    this.posts = const [],
    this.favorites= const [],
      });
}
