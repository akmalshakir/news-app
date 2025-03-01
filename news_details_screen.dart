import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class NewsDetailScreen extends StatelessWidget {
  final Article article;
  final List<Article> allArticles; // ✅ List of all articles

  NewsDetailScreen({required this.article, required this.allArticles});

  // ✅ Function to open the full article
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch URL: $url");
    }
  }

  // ✅ Extract keywords from a given text (title/description)
  List<String> _extractKeywords(String text) {
    List<String> stopWords = ["the", "is", "and", "of", "in", "to", "a", "for", "on", "with", "at", "by", "from"]; // Common stopwords
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .split(' ')
        .where((word) => word.length > 3 && !stopWords.contains(word)) // Remove short words & stopwords
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Extract keywords from the opened article's title & description
    List<String> keywords = _extractKeywords(article.title) + _extractKeywords(article.description);

    // ✅ Find similar articles based on matching keywords
    List<Article> similarArticles = allArticles.where((a) {
      if (a.title == article.title) return false; // Exclude the opened article

      List<String> articleKeywords = _extractKeywords(a.title) + _extractKeywords(a.description);
      return articleKeywords.any((keyword) => keywords.contains(keyword)); // Check for common keywords
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background Image with Hero Animation
          if (article.imageUrl.isNotEmpty)
            Hero(
              tag: article.title,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

          // ✅ Gradient Overlay
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // ✅ Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // ✅ Content Section with DraggableScrollableSheet
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Title
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8),

                      // ✅ Source & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Today", // Replace with actual date
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Divider(),

                      // ✅ Description
                      Text(
                        article.description.isNotEmpty
                            ? article.description
                            : "No detailed content available.",
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      SizedBox(height: 20),

                      // ✅ Read Full Article Button
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(article.url),
                        icon: Icon(Icons.open_in_browser),
                        label: Text("Read Full Article"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 20),

                      // ✅ Similar News Section (Now based on keyword matching)
                      if (similarArticles.isNotEmpty) ...[
                        Text(
                          "Similar News",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        // ✅ Scrollable Horizontal List
                        SizedBox(
                          height: 180, // Fix overflow by limiting height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarArticles.length,
                            itemBuilder: (context, index) {
                              final similarArticle = similarArticles[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        article: similarArticle,
                                        allArticles: allArticles,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200, // Set width to avoid overflow
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ✅ Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                        child: Image.network(
                                          similarArticle.imageUrl,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Icon(Icons.image_not_supported, size: 50),
                                        ),
                                      ),

                                      // ✅ Title
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          similarArticle.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
