import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../widgets/progress.dart';
import 'home.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<QuerySnapshot> searchResult;
  TextEditingController txtSearch = TextEditingController();

  handleSearch(value) {
    // search by display name
    Future<QuerySnapshot> users = usersRef
        .where("username", isGreaterThanOrEqualTo: value)
        .get();

    setState(() {
      searchResult = users;
    });
  }

  clearSearch() {
    txtSearch.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextFormField(
          controller: txtSearch,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search for user",
            prefixIcon: Icon(Icons.account_box),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                clearSearch();
              },
            ),
          ),
          onFieldSubmitted: (value) {
            handleSearch(value);
          },
        ),
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset(
              "assets/images/search.svg",
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 40.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  buildResultSearch() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResult,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchData = [];
        snapshot.data?.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          searchData.add(UserResult(user: user));
        });
        return ListView(
          children: searchData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResult != null ? buildResultSearch() : buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  late final User user;

  UserResult({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                ),
                title: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  user.displayName,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
