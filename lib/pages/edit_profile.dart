import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../widgets/progress.dart';
import 'home.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({required this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late User user;
  bool isLoading = false;
  TextEditingController controllerDisplayName = TextEditingController();
  TextEditingController controllerBio = TextEditingController();
  bool _validBio = true;
  bool _validDisplayName = true;
  // final _scaffKey = GlobalKey<ScaffoldState>();
  final _scaffKey = GlobalKey<ScaffoldMessengerState>();


  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    controllerDisplayName.text = user.displayName;
    controllerBio.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Container textFieldDisplayName() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: controllerDisplayName,
            decoration: InputDecoration(
                hintText: "update Display Name",
                errorText: _validDisplayName ? null : "Display Name too Short"),
          )
        ],
      ),
    );
  }

  textFieldBio() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Bio",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextField(
            controller: controllerBio,
            decoration: InputDecoration(
                hintText: "update Bio",
                errorText: _validBio ? null : "Bio too Long"),
          )
        ],
      ),
    );
  }

  updateProfileData() {
    setState(() {
      controllerDisplayName.text.trim().length < 3 ||
              controllerDisplayName.text.isEmpty
          ? _validDisplayName = false
          : true;

      controllerBio.text.trim().length > 100 ? _validBio = false : true;
    });

    if (_validBio && _validDisplayName) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": controllerDisplayName.text,
        "bio": controllerBio.text
      });

      SnackBar snackbar = const SnackBar(content: Text("Profile Updated"));
      _scaffKey.currentState!.showSnackBar(snackbar);
    }
  }

  _logoutAccount() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Home();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Profile"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
        body: isLoading
            ? circularProgress()
            : ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                      textFieldDisplayName(),
                      textFieldBio(),
                      Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton(
                          child: Text("Update Profile",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            updateProfileData();
                          }),
                      Padding(padding: EdgeInsets.all(10.0)),
                      ElevatedButton.icon(
                          onPressed: () {
                            _logoutAccount();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          label: Text(
                            "logout",
                            style: TextStyle(color: Colors.red, fontSize: 25.0),
                          ))
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
