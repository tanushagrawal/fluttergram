

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'as io ;
import 'package:firebase_auth/firebase_auth.dart';

void addData(io.File file,String username, String phonenumber, String password, String description, int birtdate, int birtmonth, int birthyear, int age,String gender) async{
  String url;
  final _auth = FirebaseAuth.instance;
  _auth.signInWithEmailAndPassword(email: "agarwalom128@gmail.com", password:"9652534488" );

  if (file!=null){
    StorageReference reference = FirebaseStorage.instance.ref().child("/profiles/$username.jpg");
    StorageUploadTask uploadTask = reference.putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await reference.getDownloadURL();
  }


  final DocumentReference =
      Firestore.instance.collection("users").document(username).setData({
    "username":    username,
    "phonenumber":  phonenumber,
    "password":    password,
    "description": description,
    "birtdate":    birtdate,
    "birtmonth":   birtmonth,
    "birthyear":   birthyear,
    "age":         age,
    "gender":     gender,
    "profile image":url,
  });

}

Future<bool> uploadImage(io.File file,String username)async{
  StorageReference reference = FirebaseStorage.instance.ref().child("profiles/").child("newimg1.imgd");
  StorageUploadTask uploadTask = reference.putFile(file);
  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
 print(reference.getDownloadURL());
}

