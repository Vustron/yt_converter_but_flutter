// utils

// youtube video data factory
class YoutubeVideo {
  // init data
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String duration;

  // init constructor
  YoutubeVideo(
      {required this.title,
      required this.thumbnailUrl,
      required this.channelTitle,
      required this.duration});

  // init factory
  factory YoutubeVideo.fromJson(Map<String, dynamic> json,
      {String duration = 'N/A'}) {
    final snippet = json['snippet'];
    return YoutubeVideo(
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
      channelTitle: snippet['channelTitle'],
      duration: duration,
    );
  }

  // return data
  YoutubeVideo copyWith({String? duration}) {
    return YoutubeVideo(
      title: title,
      thumbnailUrl: thumbnailUrl,
      channelTitle: channelTitle,
      duration: duration ?? this.duration,
    );
  }
}