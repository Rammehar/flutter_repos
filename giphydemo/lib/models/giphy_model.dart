class GiphyModel {
  final String title;
  final String url;

  GiphyModel(this.title, this.url);

  factory GiphyModel.fromJson(Map<String, dynamic> json) {
    final String title = json['title'];
    final String imageUrl = json['images']['original']['url'];
    return GiphyModel(title, imageUrl);
  }
}
