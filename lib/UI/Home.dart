import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:waelhassan/Utils/Post.dart';
import 'package:waelhassan/Utils/Sample.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<dynamic>> _futureGetData;
  ScrollController _scrollController;
  List<Post> post = [];
  var base = 'https://waelhassan.com/';
  var api = "wp-json/wp/v2/";
  var pageNum = 1;
  var endpoint = "posts?page=";
  bool _infiniteStop;

  @override
  void initState() {
    super.initState();
    _futureGetData = getData(1);
    _scrollController =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _scrollController.addListener(_scrollListner);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<List<dynamic>> getData(int page) async {
    var res = await http.get(base + api + endpoint + "$page");
    if (this.mounted) {
      if (res.statusCode == 200) {
        setState(() {
          post.addAll(
              json.decode(res.body).map((m) => Post.fromJson(m)).toList());
          if (post.length % 10 != 0) {
            _infiniteStop = true;
          }
        });
        return post;
      } else {
        setState(() {
          _infiniteStop = true;
        });
      }
    }
    print("Posts lengt" + post.length.toString());
    return post;
  }

  _scrollListner() {
    var isEnd = _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange;
    if (isEnd) {
      setState(() {
        pageNum += 1;
        _futureGetData = getData(pageNum);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wael Hassan"),
      ),
      body: Container(
          child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: _futureGetData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) return Container();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: FutureBuilder(
                        future: _futureGetData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.length == 0) return Container();
                            return Column(children: [
                              Column(
                                  children: snapshot.data.map((item) {
                                final heroId = item.id.toString() + "-latest";
                                return articleBox(context, item, heroId);
                              }).toList()),
                              !_infiniteStop
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()
                            ]);
                          }
                        },
                      )),
                );
              }
              return Container(
                child: CircularProgressIndicator(),
              );
            }),
      )),
    );
  }
}
