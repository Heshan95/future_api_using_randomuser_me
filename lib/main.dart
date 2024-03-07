import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:future_api_using_randomuser_me/model/User.dart';
import 'package:future_api_using_randomuser_me/screens/User_details.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Builder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> getUsers() async {
    var url = Uri.parse('https://randomuser.me/api?results=50');
    late http.Response response;
    List<User> userList = [];
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        Map userData = jsonDecode(response.body);
        List<dynamic> user = userData['results'];

        for (var item in user) {
          var email = item['email'];
          var name = item['name']['first'] + " " + item['name']['last'];
          var id = item['login']['uuid'];
          var avatar = item['picture']['thumbnail'];

          User user = User(email, name, id, avatar);
          userList.add(user);
        }
      } else {
        return Future.error(
            'Something went to wrong!!, ${response.statusCode}');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('Waiting..'),
            );
          } else {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].avatar),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetails(snapshot.data[index]),
                          ));
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
