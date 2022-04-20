import 'dart:convert';

import 'package:pragtechtask/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<List<UserModel>> sharedpref(var listdata) async {
  List<UserModel> _likedList = listdata;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsondata = jsonEncode(_likedList);
  await prefs.setString('liked_key', jsondata);
  final String? likedString = await prefs.getString('liked_key');
  //final List<UserModel> _liked = UserModel.decode(likedString);

  return _likedList;
}


