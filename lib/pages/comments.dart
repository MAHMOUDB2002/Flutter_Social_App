import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'home.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String mediaUrl;

  Comments({required this.postId, required this.ownerId, required this.mediaUrl});
  @override
  _CommentsState createState() => _CommentsState(
      postId: this.postId, ownerId: this.ownerId, mediaUrl: this.mediaUrl);
}

class _CommentsState extends State<Comments> {
  final String postId;
  final String ownerId;
  final String mediaUrl;
  _CommentsState({required this.postId, required this.ownerId, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    TextEditingController commnetController = new TextEditingController();

    buildComments() {
      return StreamBuilder(
        stream: commentsRef.doc(postId).collection("comments").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> comments = [];
          snapshot.data!.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });

          return ListView(
            children: comments,
          );
        },
      );
    }

    addComment() {
      commentsRef.doc(postId).collection("comments").add({
        "username": currentUser.username,
        "comment": commnetController.text,
        "timestamp": timestamp,
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id,
      });
      feedsRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .set({
        "type": "comments",
        "commentData": commnetController.text,
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });

      commnetController.clear();
    }

    return Scaffold(
      appBar: header(context, titleText: "Commnets"),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commnetController,
              decoration: InputDecoration(labelText: "Write a commnets"),
            ),
            trailing: OutlinedButton(
                child: Text("Post"),
                onPressed: () {
                  addComment();
                }),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {required this.username,
      required this.userId,
      required this.avatarUrl,
      required this.comment,
      required this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc["username"],
      userId: doc["userId"],
      comment: doc["comment"],
      timestamp: doc["timestamp"],
      avatarUrl: doc["avatarUrl"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timestamp.toDate().toString()),
        )
      ],
    );
  }
}
