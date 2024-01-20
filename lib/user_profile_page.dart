
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  String profilePicUrl;
  UserProfilePage({required this.profilePicUrl});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  CroppedFile? croppedImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             croppedImg != null ? ClipRRect(
               borderRadius: BorderRadius.circular(50),
               child: Image.file(
                 File(croppedImg!.path),
                 fit: BoxFit.fill,
                 width: 100,
                 height: 100,
               ),
             ) : widget.profilePicUrl != "" ? ClipRRect(
               borderRadius: BorderRadius.circular(50),
               child: Image.network(
                 widget.profilePicUrl,
                 fit: BoxFit.fill,
                 width: 100,
                 height: 100,
               ),
             ) : Icon(Icons.account_circle),
            SizedBox(
              height: 11,
            ),
            ElevatedButton(
                onPressed: () {
                  openImagePicker();
                },
                child: Text('Choose Picture')),
            SizedBox(
              height: 11,
            ),
            croppedImg != null ? ElevatedButton(onPressed: () {
              uploadImg();
            }, child: Text('Upload Picture')) : Text('Select an Image to Upload'),
          ],
        ),
      ),
    );
  }

  void openImagePicker() async {
    var pickedImg = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImg != null) {
      croppedImg = await ImageCropper().cropImage(
        sourcePath: pickedImg.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      setState(() {

      });
    }
  }

  void uploadImg() async{

    var currTimeMillis = DateTime.now().millisecondsSinceEpoch;

    var storage = FirebaseStorage.instance;

    var storageRef = storage.ref().child("images/profilePictures/IMG_$currTimeMillis.jpg");

    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");

    try{



      storageRef.putFile(File(croppedImg!.path)).then((value) async{
        //creating image url
        var imgUrl = await value.ref.getDownloadURL();
        // when uploading is complete
        var fireStore = FirebaseFirestore.instance;
        ///updating current profile pic
        fireStore.collection("users").doc(userId).update({
          'profilePic' : imgUrl
        });

        ///adding profile pic url in collection
        fireStore.collection("users").doc(userId).collection("profilePics").add({
          'img' : imgUrl,
          'uploadedAt' : currTimeMillis
        });
      });

    } on FirebaseException catch(e){
      print("Error Uploading..$e");
    }

  }
}
