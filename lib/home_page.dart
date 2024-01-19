import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'note_model.dart';

class HomePage extends StatefulWidget {
  String userId;

  HomePage({required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore firestore;
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Notes'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection("users")
            .doc(widget.userId)
            .collection("notes").where("title", whereIn: [""])
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Couldn\'t fetch notes!!'),
              );
            } else if (snapshot.hasData) {
              var mData = snapshot.data!.docs;
              return mData.isNotEmpty ? ListView.builder(
                  itemCount: mData.length,
                  itemBuilder: (_, index) {
                    var eachDocId = mData[index].id;
                    print(eachDocId);
                    NoteModel currNote = NoteModel.fromMap(mData[index].data());
                    return ListTile(
                      title: Text(currNote.title),
                      subtitle: Text(currNote.desc),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  titleController.text = currNote.title;
                                  descController.text = currNote.desc;
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        return Container(
                                          height: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: titleController,
                                                ),
                                                SizedBox(
                                                  height: 11,
                                                ),
                                                TextField(
                                                  controller: descController,
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          firestore.collection("users")
                                                              .doc(widget.userId)
                                                              .collection("notes")
                                                              .doc(eachDocId)
                                                              .update(NoteModel(
                                                              title: titleController.text
                                                                  .toString(),
                                                              desc: descController.text
                                                                  .toString())
                                                              .toMap())
                                                              .then((value) {
                                                            print("Note Updated!!");
                                                            Navigator.pop(context);
                                                          }).catchError((e) {
                                                            return "Note not Updated";
                                                          });
                                                        },
                                                        child: Text('Update')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Cancel'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }, icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  firestore
                                      .collection("users")
                                      .doc(widget.userId)
                                      .collection("notes")
                                      .doc(eachDocId)
                                      .delete();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    );
                  }) : Center(
                child: Text('No Notes yet!!', style: TextStyle(fontSize: 25),),
              );
            }
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var collRef = firestore.collection("users");
          titleController.text = "";
          descController.text = "";
          /// to add data in firestore
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return Container(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        TextField(
                          controller: descController,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  collRef
                                      .doc(widget.userId)
                                      .collection("notes")
                                      .add(NoteModel(
                                              title: titleController.text
                                                  .toString(),
                                              desc: descController.text
                                                  .toString())
                                          .toMap())
                                      .then((value) {
                                    print("Note added!!");
                                    Navigator.pop(context);
                                  }).catchError((e) {
                                    return "Note not Added";
                                  });
                                },
                                child: Text('Add')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

//{
//             "title" : "Learning is Earning",
//             "desc" : "Start from Today, right here, right now!!",
//           }

//FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         future: firestore.collection("notes").get(),
//         builder: (_, snapshot){
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return Center(child: CircularProgressIndicator(),);
//           } else {
//             if(snapshot.hasError){
//               return Center(
//                 child: Text('Couldn\'t fetch notes!!'),
//               );
//             } else if(snapshot.hasData){
//               var mData = snapshot.data!.docs;
//               return ListView.builder(
//                 itemCount: mData.length,
//                   itemBuilder: (_, index){
//                 NoteModel currNote = NoteModel.fromMap(mData[index].data());
//                 return ListTile(
//                   title: Text(currNote.title),
//                   subtitle: Text(currNote.desc),
//                 );
//               });
//             }
//           }
//           return Container();
//         },
//       ),
