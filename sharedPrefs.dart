import 'package:pragtechtask/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreference {
  save(data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var mylikedList = data;
    final myItemsAsJsonString = json.encode(mylikedList);
    await prefs.setString("KEY_1", myItemsAsJsonString);
    return 'saved';
  }

  retrieve() async {
    //const likedKey = 'liked';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? myItemsAsJsonString = prefs.getString("KEY_1");
    final String myItems = json.decode(myItemsAsJsonString!);
    List<UserModel> _modelLiked = userModelFromJson(myItems);

    print(_modelLiked);
    return _modelLiked;
  }
}
