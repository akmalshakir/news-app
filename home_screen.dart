import 'package:flutter/material.dart';
import 'package:movie_browser/screens/search_screen.dart';
import 'news_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"title": "Technology", "icon": Icons.computer, "color": Colors.blue},
    {"title": "Business", "icon": Icons.business, "color": Colors.green},
    {"title": "Sports", "icon": Icons.sports_soccer, "color": Colors.orange},
    {"title": "Entertainment", "icon": Icons.movie, "color": Colors.red},
    {"title": "Health", "icon": Icons.health_and_safety, "color": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All News"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // Navigate to NewsSearchScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsSearchScreen(),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsListScreen(category: categories[index]["title"]!),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                shadowColor: categories[index]["color"].withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categories[index]["icon"],
                      size: 50,
                      color: categories[index]["color"],
                    ),
                    SizedBox(height: 10),
                    Text(
                      categories[index]["title"]!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
