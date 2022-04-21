import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pragtechtask/api_service.dart';
import 'package:pragtechtask/model/user.dart';
import 'package:pragtechtask/sharedPrefs.dart';
// import 'package:pragtechtask/sharedPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  SharedPreference sharedPreference = new SharedPreference();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<UserModel>? _userModel = [];
  List<UserModel> _liked = [];
  // late List<UserModel> _likedList;

  @override
  void initState() {
    super.initState();
    _getData();
    _liked = SharedPreference().retrieve();
  }

  void _getData() async {
    _userModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _liked.length < 1
              ? "PRAG TECH - SANTHOSH TASK"
              : "PRAG TECH - SANTHOSH TASK -  ${_liked.length} Members liked",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _userModel == null || _userModel!.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _userModel!.length,
                itemBuilder: (context, index) {
                  UserModel liked = _userModel![index];

                  final alreadySaved = _liked.contains(liked);

                  return Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_userModel![index].id.toString()),
                            Text(_userModel![index].name),
                            Text(_userModel![index].email),
                            Text(_userModel![index].phone),
                            IconButton(
                              icon: Icon(
                                alreadySaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: alreadySaved ? Colors.green : null,
                                semanticLabel: alreadySaved
                                    ? 'Remove from liked'
                                    : 'Save Liked',
                              ),
                              onPressed: () {
                                setState(() {
                                  if (alreadySaved) {
                                    _liked.remove(liked);
                                  } else {
                                    _liked.add(liked);
                                  }
                                  String jsondata = jsonEncode(_liked);
                                  //  print(jsondata);
                                  SharedPreference().save(jsondata);
                                  // const String key = "users";
                                  //  List<UserModel> users = _liked;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

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
    final List<UserModel> myItems = json.decode(myItemsAsJsonString!);
    _liked = myItems;
  }
}
