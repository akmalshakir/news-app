import 'package:flutter/material.dart';
import '../models/article.dart';
import '../screens/news_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article, allArticles: [],)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 4,
        child: Column(
          children: [
            article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl, height: 150, fit: BoxFit.cover)
                : Container(height: 150, color: Colors.grey),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                article.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
