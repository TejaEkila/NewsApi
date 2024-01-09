import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsWithModel extends StatefulWidget {
  const NewsWithModel({super.key});

  @override
  State<NewsWithModel> createState() => _NewsWithModelState();
}

class _NewsWithModelState extends State<NewsWithModel> {
  Future<String> newsapi() async {
    Uri url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e63584161b0547aeb054c1f390eccfd2');
    print(url.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body.toString());
    }
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Page"),
      ),
      body: FutureBuilder<String>(
        future: newsapi(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget w;
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var body = json.decode(data);
            int count = body['articles'].length;
            print(count);
            w = Center(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: count,
                
                itemBuilder: (BuildContext context, int index) {
                  String author = body["articles"][index]["author"].toString();
                  String title = body["articles"][index]["title"].toString();
                  String description = body["articles"][index]["description"].toString();
                  String url = body["articles"][index]["url"].toString();
                  String urlToImage = body["articles"][index]["urlToImage"].toString();
                  String publishedAt = body["articles"][index]["publishedAt"].toString();
                  String content = body["articles"][index]["content"].toString();
                   return Card(

                    elevation: 2,
                    color: const Color.fromARGB(255, 247, 245, 238),
                    child: Container(
                     
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          "${author}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          publishedAt.substring(0, 10) + "  ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.network(
                          urlToImage,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const SizedBox();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MoreNews(title: title, author: author, publishedAt: publishedAt, description: description, urlToImage: urlToImage, content: content, url: url)));
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "More..." + " ",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            w = Text('error with api ${snapshot.hasError}');
          } else {
            w = Center(
              child: CircularProgressIndicator(),
            );
          }
          return w;
        },
      ),
    );
  }
}

class MoreNews extends StatelessWidget {
  MoreNews({super.key, required this.author, required this.title, required this.description, required this.url, required this.urlToImage, required this.publishedAt, required this.content});
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending News"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Title: ${title}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Author: ${author}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              "Description: ${description}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            // ignore: unnecessary_null_comparison

            Image.network(
              urlToImage,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Text('Image was Removed');
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Content: ${content}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                await launchUrl(
                  Uri.parse(url),
                );
              },
              child: Text(
                "Url: ${url}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
