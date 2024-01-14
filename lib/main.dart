import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_173/firebase_options.dart';
import 'package:firebase_173/note_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseFirestore firestore;

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
        stream: firestore.collection("notes").snapshots(),
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
              return ListView.builder(
                  itemCount: mData.length,
                  itemBuilder: (_, index) {
                    NoteModel currNote = NoteModel.fromMap(mData[index].data());
                    return ListTile(
                      title: Text(currNote.title),
                      subtitle: Text(currNote.desc),
                    );
                  });
            }
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var collRef = firestore.collection("notes");

          /// to add data in firestore
          collRef.add(NoteModel(
                      title: "Learning is Earning",
                      desc: "Start from Today, right here, right now!!")
                  .toMap())
              .then((value) {
            print("Note added!!");
          }).catchError((e) {
            return "Note note Added";
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
