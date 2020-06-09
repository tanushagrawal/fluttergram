import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';

Future<String>hashedPassword(String password) async {
  Response response =
      await get("https://api.hashify.net/hash/md5/hex?value=${password}");
  print(response.body);
  return jsonDecode(response.body)["Digest"].toString();
}
