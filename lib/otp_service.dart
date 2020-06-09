import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';

//String api_key ="KSWdjgbTXEG1IHuqpvi3JsBUyAmZFOc0DL2l8R5fxVYCerQ6M7tboC8ymn3UTSJYDkr4Wz2XcPK7O6Rg";
String api_key;
List api =[""];
Future<String> sendOtp(String otp,String phonenumber)async{
   Response response = await get("https://www.fast2sms.com/dev/bulk?authorization=${api[0]}&sender_id=FSTSMS&message=$otp&language=english&route=p&numbers=$phonenumber");
   print(response.body);
   print(response.statusCode);
   return jsonDecode(response.body)["return"].toString();
}
