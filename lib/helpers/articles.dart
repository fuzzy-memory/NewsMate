class Article{
  final String author;
  final String title;
  final String url;
  final String content;
  final String desc;

  Article({this.author, this.content, this.title, this.url, this.desc});

  @override
  String toString() {
    return 'Title: $title\nDesc: $desc\nAuthor: $author\nURL: $url\nContent:\n$content';
  }
}