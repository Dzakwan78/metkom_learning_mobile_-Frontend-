class InfoEvent {
  String title;
  String? imagePath; // path file foto lokal (dari galeri/kamera)
  String youtubeLink; // link video YouTube (opsional)
  String description;

  InfoEvent({
    required this.title,
    this.imagePath,
    this.youtubeLink = '',
    required this.description,
  });
}
