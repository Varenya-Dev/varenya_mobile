import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/widgets/posts/image_carousel.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_categories.widget.dart';
import 'package:varenya_mobile/widgets/posts/post_user_details.widget.dart';
import 'package:varenya_mobile/pages/post/post.page.dart' as PostPage;

class PostCard extends StatelessWidget {
  // Post data
  final Post post;

  // Check if the post in displayed
  // in a list or a single post page.
  final bool fullPagePost;

  PostCard({
    Key? key,
    required this.post,
    this.fullPagePost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder:
          (BuildContext context, ConnectivityResult result, Widget child) {
        final bool connected = result != ConnectivityResult.none;

        return GestureDetector(
          onTap: fullPagePost
              ? null
              : connected
                  ? () {
                      // Push the Full Post Page on
                      // top with required arguments.
                      Navigator.of(context).pushNamed(
                        PostPage.Post.routeName,
                        arguments: this.post.id,
                      );
                    }
                  : null,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCategories(
              categories: this.post.categories,
              duration: DateTime.now().difference(
                this.post.createdAt,
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                this.post.title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
            PostUserDetails(
              post: this.post,
              serverUser: this.post.user,
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                '${this.post.comments.length} responses',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
