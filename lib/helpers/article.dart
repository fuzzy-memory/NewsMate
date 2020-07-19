class Article {
  final String author;
  final String title;
  final String url;
  final String content;
  final String desc;
  final String imgURL;
  final String src;
  final String pub;

  Article({
    this.pub,
    this.src,
    this.author,
    this.content,
    this.title,
    this.url,
    this.desc,
    this.imgURL,
  });

  @override
  String toString() {
    return 'Source: $imgURL\nTitle: $title\nDesc: $desc\nAuthor: $author\nURL: $url\nContent:\n$content';
  }
}