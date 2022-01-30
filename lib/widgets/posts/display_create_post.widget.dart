import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/pages/post/new_post.page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

class DisplayCreatePost extends StatelessWidget {
  const DisplayCreatePost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          NewPost.routeName,
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
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Row(
          children: [
            Consumer<UserProvider>(
              builder: (
                BuildContext context,
                UserProvider user,
                _,
              ) =>
                  Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                child: ProfilePictureWidget(
                  imageUrl: user.user.photoURL ?? '',
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
            ),
            Text(
              'Write Something...',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.022,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
