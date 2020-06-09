
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';
   
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;

  Future getImage(context, {CropStyle style = CropStyle.rectangle}) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
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
        // call set state here 
        imageFile = imagefile['image_filtered'];
      }
      print(imageFile.path);
    }
  