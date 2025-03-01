import 'package:flutter/material.dart';
import 'news_detail_screen.dart';
import '../models/article.dart';
import '../services/news_service.dart';

class NewsSearchScreen extends StatefulWidget {
  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Article> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = "";
  void _searchNews() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return; // Don't search if input is empty
    setState(() {
      _isLoading = true;
      _errorMessage = "";});
    try {
      List<Article> results = await NewsService().searchNews(query);
      setState(() {
        _searchResults = results;});} catch (e) {
      setState(() {
        _errorMessage = "Error fetching results. Please try again.";
      });}
    finally {
      setState(() {
        _isLoading = false;});}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search News"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter search keyword...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchResults = []; // Clear results
                    });
                  },
                )
                    : null,
              ),
              onSubmitted: (_) => _searchNews(), // Trigger search on submit
            ),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
          else if (_searchResults.isEmpty)
              Center(child: Text("No results found"))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: _searchResults[index].imageUrl.isNotEmpty
                          ? Image.network(
                        _searchResults[index].imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image, size: 50, color: Colors.grey),
                      title: Text(_searchResults[index].title),
                      subtitle: Text(_searchResults[index].source),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(
                              article: _searchResults[index],
                              allArticles: _searchResults,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
