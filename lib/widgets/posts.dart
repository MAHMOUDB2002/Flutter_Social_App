import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/widgets/progress.dart';

import '../model/user.dart';
import '../pages/comments.dart';
import '../pages/home.dart';


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post(
      {required this.postId,
      required this.ownerId,
     required this.username,
      required this.location,
    required  this.description,
    required  this.mediaUrl,
    required  this.likes});

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc["postId"],
      ownerId: doc["ownerId"],
      username: doc["username"],
      location: doc["location"],
      description: doc["description"],
      mediaUrl: doc["mediaUrl"],
      likes: doc["likes"],
    );
  }

  int getLikeCounts(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      ownerId: this.ownerId,
      username: this.username,
      location: this.location,
      description: this.description,
      mediaUrl: this.mediaUrl,
      likes: this.likes,
      likeCount: getLikeCounts(this.likes));
}

class _PostState extends State<Post> {
  final String? CurrentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  Map likes;
  int likeCount;
 late bool isLiked;
  bool showHeart = false;

  _PostState(
      {required this.postId,
      required this.ownerId,
      required this.username,
      required this.location,
      required this.description,
      required this.mediaUrl,
      required this.likes,
      required this.likeCount});

  buildPostHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data as DocumentSnapshot<Object?>);
        // snapshot.data as DocumentSnapshot<Object?>
        // snapshot.data
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: Text(user.username,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              subtitle: Text(location),
              trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    print("delete");
                  }),
            ),
            Container(child: Text(description == null ? "" : description))
          ],
        );
      },
    );
  }

  buildPostImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            handleLikePost();
          },
          child: CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.cover,
              height: 300.0,
              width: MediaQuery.of(context).size.width),
        ),
        showHeart
            ? Animator(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                tween: Tween(begin: 0.8, end: 1.4),
                cycles: 0,
                builder: (context, anim, child) => Transform.scale(
                  scale: anim.value,
                  child: Icon(Icons.favorite, size: 170.0, color: Colors.red),
                ),
              )
            : Text("")
      ],
    );
  }

  addLikeToActivityFeed() {
    feedsRef
        .doc(ownerId)
        .collection("feedItems")
        .doc(postId)
        .set({
      "type": "like",
      "username": currentUser.username,
      "userId": currentUser.id,
      "userProfileImg": currentUser.photoUrl,
      "postId": postId,
      "mediaUrl": mediaUrl,
      "timestamp": timestamp,
    });
  }

  removeLikeFromActivityFeed() {
    feedsRef
        .doc(ownerId)
        .collection("feedItems")
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleLikePost() {
    bool _isLiked = likes[CurrentUserId] == true;
    if (_isLiked) {
      postsRef
          .doc(ownerId)
          .collection("usersPosts")
          .doc(postId)
          .update({'likes.$CurrentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[CurrentUserId] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .doc(ownerId)
          .collection("usersPosts")
          .doc(postId)
          .update({'likes.$CurrentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[CurrentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                "$likeCount likes",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Divider(),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: Container(
                child: GestureDetector(
                    onTap: () {
                      handleLikePost();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 28.0,
                            color: Colors.pink,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text("Like")),
                        ],
                      ),
                    )),
              )),
              new Expanded(
                  child: Container(
                child: GestureDetector(
                    onTap: () {
                      showComment(context,
                          postId: postId, ownerId: ownerId, mediaUrl: mediaUrl);
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text("Comment"),
                        )
                      ],
                    )),
              )),
              new Expanded(
                  child: Container(
                child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          size: 28.0,
                          color: Colors.black,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text("Share"),
                        )
                      ],
                    )),
              )),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = likes[CurrentUserId] == true;
    return Container(
      child: Column(
        children: <Widget>[
          buildPostHeader(),
          buildPostImage(),
          buildPostFooter(),
        ],
      ),
    );
  }
}

showComment(context, {required String postId, required String ownerId, required String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(postId: postId, ownerId: ownerId, mediaUrl: mediaUrl);
  }));
}
