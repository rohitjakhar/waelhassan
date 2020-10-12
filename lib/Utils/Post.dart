class Post {
  final int id;
  final String title;
  final String content;
  final String description;
  final String image;

  Post({this.id, this.title, this.content, this.description, this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title']['rendered'],
        content: json['content']['rendered'],
        description: json['excerpt']['rendered'],
        image: json['jetpack_featured_media_url']);
  }

  factory Post.fromDatabaseJson(Map<String, dynamic> data) => Post(
      id: data['id'],
      title: data['title'],
      content: data['content'],
      description: data['description'],
      image: data['image']);

  Map<String, dynamic> toDatabaseJson() => {
        'id': this.id,
        'title': this.title,
        'content': this.content,
        'description': this.description,
        'image': this.image
      };
}
