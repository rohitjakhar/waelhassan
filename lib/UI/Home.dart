import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var base = 'https://waelhassan.com/';
  var api = "wp-json/wp/v2/";
  var post = "posts";

  List data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await http.get(base + api + post);

    data = jsonDecode(res.body);

    setState(() {
      data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wael Hassan"),
      ),
      body: Container(
          child: ListView.builder(
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
                                data[index]['jetpack_featured_media_url']),
                            Center(
                              child: Text(
                                data[index]['title']['rendered'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(data[index]['excerpt']['rendered'])
                          ],
                        ),
                      )),
                );
              },
              itemCount: data.length)),
    );
  }
}
