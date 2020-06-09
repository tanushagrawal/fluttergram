import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/screens/create_userprofile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  String username;
  ImageUploader({@required this.username});
  @override
  _ImageUploaderState createState() => new _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;

  Future getImage(BuildContext context,
      {CropStyle style = CropStyle.rectangle,
      @required ImageSource imageSource}) async {
    imageFile = await ImagePicker.pickImage(source: imageSource);
    var cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      cropStyle: style,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'fluttergram',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    fileName = basename(cropped.path);
    var image = imageLib.decodeImage(cropped.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text(
            "fluttergram",
            style: GoogleFonts.pacifico(color: Colors.black, fontSize: 27),
          ),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: null),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: new Text(
          "fluttergram",
          style: GoogleFonts.pacifico(color: Colors.black, fontSize: 27),
        ),
      ),
      body: Center(
        child: new Container(
          child: imageFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 320),
                        child: new Text(
                          ' From Where Do You want to select Image',
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            getImage(context, imageSource: ImageSource.gallery);
                          },
                          child: Text(
                            "Gallery",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            getImage(context, imageSource: ImageSource.camera);
                          },
                          child: Text(
                            "Camera",
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.file(
                        imageFile,
                        height: 500,
                        width: 500,
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {
                          final _auth = FirebaseAuth.instance;
                          _auth.signInWithEmailAndPassword(
                              email: "agarwalom128@gmail.com",
                              password: "9652534488");
                          StorageReference reference = FirebaseStorage.instance
                              .ref()
                              .child("/posts/${widget.username}/img.jpg");
                          StorageUploadTask uploadTask =
                              reference.putFile(imageFile);
                          StorageTaskSnapshot taskSnapshot =
                              await uploadTask.onComplete;
                          String url = await reference.getDownloadURL();
                          final doc = await Firestore.instance
                              .collection("users")
                              .where("username", isEqualTo: widget.username)
                              .getDocuments();
                          var id = doc.documents[0].documentID;
                          final imageStatus = Firestore.instance
                              .collection("users")
                              .document(id)
                              .collection("posts")
                              .document("images")
                              .collection("files")
                              .document()
                              .setData({
                            "title": "new pic",
                            "url": url,
                            "timeStamp": Timestamp.now(),
                            "likes": 0,
                            "comments": 0,
                          });
                          print(imageStatus);
                          Navigator.pop(context);
                        },
                        child: Text("Upload"),
                      )
                    ],
                  ),
                )),
        ),
      ),
    );
  }
}
