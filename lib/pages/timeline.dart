import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// final usersRef = Firestore.instance.collection("users");

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    //getUsers();
    // createuser();
    //updateuser();
    // deleteuser();
    //getUsersById();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("timeLine"),
    );
  }
}

// child: Scaffold(
// appBar: header(context, titleText: "TimeLineState"),
// body:
// StreamBuilder<QuerySnapshot>(
// // for real time  عشان يجيب الداتا بددون ما اعمل ريلود للتطبيق
// stream: usersRef.snapshots(),
// builder: (context, snapshot) {
// if (!snapshot.hasData) {
// return circularProgress(); //   حيعمل لودينج progress
// }
// // بعدين حيجيب الداتا
// // جيب الداتا وحولها لمصفوفة وحط المصفوفة داخل اليست فيو
// List<Text> child = snapshot.data!.documents
//     .map((user) => Text(user["name"]))
//     .toList();
// return ListView(
// children: child,
// );
// },
// ),
// ),

// ListView(
// children: users.map((users) => Text(users["name"],style: TextStyle(fontSize: 20.0),)).toList(),
// )

// functions firebase learning

// createuser() {
//   // add to firestore
//   usersRef.document("hkgfo3487rgif39re").setData({
//     "name": "Mohammed",
//     "isAdmin": false,
//     "postCount": 3,
//   });
// }
//
// updateuser() async {
//   // التعديل نتاكد انو المستخدم موجود قبل ما نعمل تحديث
//   final DocumentSnapshot doc =
//   await usersRef.document("hkgfo3487rgif39re").get();
//
//   if (doc.exists) {
//     // if exists update it
//     doc.reference.updateData({
//       "name": "lolo",
//       "isAdmin": false,
//       "postCount": 22222,
//     });
//   }
//
//   // update data from firestore
//   // usersRef.document("hkgfo3487rgif39re").updateData({
//   //   "name": "samy",
//   //   "isAdmin": true,
//   //   "postCount": 277656565,
//   // });
// }
//
// deleteuser() async {
//   // delete data from firestore
//   final DocumentSnapshot doc =
//   await usersRef.document("hkgfo3487rgif39re").get();
//
//   if (doc.exists) {
//     // if exists delete it
//     doc.reference.delete();
//   }
// }
//
// getUsers() async {
//   QuerySnapshot snapshot = await usersRef
//   // .where("name", isEqualTo: "moo")
//   // .where("isAdmin", isEqualTo: true)
//   // .where("postCount", isLessThanOrEqualTo: 6)
//   // .orderBy("postCount", descending: true)// top to down // false down to top
//   //.limit(1) // pring 1 post
//       .getDocuments();
//   // "isAdmin", isEqualTo: true
//   // "name", isEqualTo: "moo"
//   // "postCount", isLessThanOrEqualTo: 6
//
//   // snapshot.documents.forEach((DocumentSnapshot doc) {
//   //   // هيك وصلنا للرو اللي داخل اليوزرز
//   //   print(doc.data); // print all users data
//   //   print(doc.documentID); // print user id
//   //   print(doc.exists); // print all user is exsit or not
//   //  });
//   setState(() {
//     users = snapshot.documents;
//   });
// }
//
// getUsersById() async {
//   final String id = "ekKJ5xiGYiydNOtQXIgW";
//   final DocumentSnapshot doc = await usersRef.document(id).get();
//   print(doc.data);
//   // جيب الداتا تعت المستخدم هاد
//   print(doc.documentID); // print user id
//   print(doc.exists); // print all user is exsit or not
// }
