//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/posts_screen.dart';
import 'package:flutter_final_project/pages/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'home.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getFeedData() async {
    QuerySnapshot snapShot = await feedsRef
        .doc(currentUser.id)
        .collection("feedItems")
        .orderBy("timestamp", descending: true)
        .limit(50)
        .get();

    List<ActivityFeedItem> feedItems = [];
    snapShot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "activitFeeds"),
      body: FutureBuilder(
        future: getFeedData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      ),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem(
      {required this.username,
      required this.userId,
      required this.type,
      required this.mediaUrl,
      required this.postId,
      required this.userProfileImg,
      required this.commentData,
      required this.timestamp});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc["username"],
      userId: doc["userId"],
      commentData: doc["commentData"],
      mediaUrl: doc["mediaUrl"],
      postId: doc["postId"],
      timestamp: doc["timestamp"],
      type: doc["type"],
      userProfileImg: doc["userProfileImg"],
    );
  }
  late String activityItemText;
  late Widget mediaPreview;

  configureMediaPreview(context) {
    if (type == "like" || type == "comments") {
      mediaPreview = GestureDetector(
        onTap: () {
          showPost(context);
        },
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(mediaUrl),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text("");
    }

    if (type == "like") {
      activityItemText = "liked your post";
    } else if (type == "follow") {
      activityItemText = "is follow you";
    } else if (type == "comments") {
      activityItemText = "replied: $commentData";
    } else {
      activityItemText = "Error : $type";
    }
  }

  showPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PostScreen(postId: postId, userId: userId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        child: ListTile(
          title: GestureDetector(
            onTap: () {
              showProfile(context, profileId: userId);
            },
            child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' $activityItemText',
                      )
                    ])),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(context, {profileId}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Profile(profileId: profileId);
  }));
}
