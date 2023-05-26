import 'package:flutter/material.dart';
import 'package:flutter_final_project/widgets/posts.dart';
import 'custom_image.dart';

class PostTile extends StatefulWidget {
  final Post post;
  PostTile({required this.post});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: cachedNetworkImage(widget.post.mediaUrl),
    );
  }
}
