import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:waelhassan/Utils/Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var base = 'https://waelhassan.com/';
  var api = "wp-json/wp/v2/";
  var pageNum = 1;
  var endpoint = "posts?page=";

  Future<List<Post>> getData() async {
    var res = await http.get(base + api + endpoint + pageNum.toString());
    var data = jsonDecode(res.body);

    List<Post> post = [];
    for (var i in data) {
      Post posts = Post(i['title']['rendered'], i['jetpack_featured_media_url'],
          i['excerpt']['rendered']);
      post.add(posts);
    }
    print("Posts lengt" + post.length.toString());
    return post;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wael Hassan"),
      ),
      body: Container(
          child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    
                      itemBuilder: (BuildContext context, int index) {
                    
                       return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(
                                        snapshot.data[index].imgeLink),
                                    Center(
                                      child: Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Text(snapshot.data[index].des)
                                  ],
                                ),
                              )),
                        );
                      },
                      itemCount: snapshot.data.length);
                }
              })),
    );
  }
}
