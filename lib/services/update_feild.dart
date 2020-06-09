import 'package:cloud_firestore/cloud_firestore.dart';

void updateField(String collectionname,String docid,String fieldname,var value){
 Firestore.instance
 .collection(collectionname)
 .document(docid)
 .updateData({fieldname:value});
}