import 'package:flutter/material.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/post/post.model.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

class FullPostUserDetails extends StatelessWidget {
  const FullPostUserDetails({
    Key? key,
    required this.context,
    required Post? post,
  })  : _post = post,
        super(key: key);

  final BuildContext context;
  final Post? _post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              child: ProfilePictureWidget(
                imageUrl: this._post!.user.role == Roles.PROFESSIONAL
                    ? this._post!.user.doctor!.imageUrl
                    : '',
                size: MediaQuery.of(context).size.width * 0.1,
              ),
            ),
            Text(
              this._post!.user.role == Roles.PROFESSIONAL
                  ? "Dr. ${this._post!.user.doctor!.fullName}"
                  : this._post!.user.randomName!.randomName,
            )
          ],
        ),
      ],
    );
  }
}