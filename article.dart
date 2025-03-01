class Article {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final String author;
  final String publishedAt;
  final String content;
  Article({
    required this.title, required this.description, required this.url, required this.imageUrl,
    required this.source, required this.author, required this.publishedAt, required this.content,
  });
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? "No Title",
      description: json['description'] ?? "No Description",
      url: json['url'] ?? "",
      imageUrl: json['urlToImage'] ?? "",
      source: json['source']?['name'] ?? "Unknown Source",
      author: json['author'] ?? "Unknown Author",
      publishedAt: json['publishedAt'] ?? "Unknown Date",
      content: json['content'] ?? "Content not available",
    );
  }}



