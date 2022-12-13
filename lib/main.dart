import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Creating a class user to store the data;
class ZMap {
  final String currentMap;
  final String remainingTimer;
  final String nextMap;
  final int durationInMinutes;

  ZMap({
    required this.currentMap,
    required this.remainingTimer,
    required this.nextMap,
    required this.durationInMinutes,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Applying get request.

  late ZMap zMap;
  late Future<dynamic> getRequest;

  @override
  initState() {
    super.initState();
    getRequest = _getRequest();
  }

  Future<String> _getRequest() async {
    //replace your restFull API here.
    String url =
        "https://api.mozambiquehe.re/maprotation?auth=679af8157ac21dd1e398264bc73c7d6d";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('status code is 200');
      var responseData = json.decode(response.body);
      print(responseData["current"]["map"]);
      print(responseData["current"]["remainingTimer"]);
      print(responseData["next"]["map"]);
      print(responseData["next"]["DurationInMinutes"]);

      //Creating a list to store input data;
      zMap = ZMap(
          currentMap: responseData["current"]["map"],
          remainingTimer: responseData["current"]["remainingTimer"],
          nextMap: responseData["next"]["map"],
          durationInMinutes: responseData["next"]["DurationInMinutes"]);
    } else {
      return 'Error';
    }
    //Adding user to the list.
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 170),
          child: FutureBuilder(
            future: _getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Column(children: [
                        Text(
                          zMap.currentMap,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Remaining Time:'),
                            Text(
                              zMap.remainingTimer,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, top: 60),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.orangeAccent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            zMap.nextMap,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Duration:'),
                              Text(
                                zMap.durationInMinutes.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text("Refresh"),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
