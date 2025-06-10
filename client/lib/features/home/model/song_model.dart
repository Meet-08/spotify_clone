// ignore_for_file: ""
import 'dart:convert';

class SongModel {
  final int id;
  final String songName;
  final String artist;
  final String hexCode;
  final String songUrl;
  final String thumbnailUrl;
  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.hexCode,
    required this.songUrl,
    required this.thumbnailUrl,
  });

  SongModel copyWith({
    int? id,
    String? songName,
    String? artist,
    String? hexCode,
    String? songUrl,
    String? thumbnailUrl,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      artist: artist ?? this.artist,
      hexCode: hexCode ?? this.hexCode,
      songUrl: songUrl ?? this.songUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'songName': songName,
      'artist': artist,
      'hexCode': hexCode,
      'songUrl': songUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: (map['id'] ?? 0) as int,
      songName: (map['songName'] ?? '') as String,
      artist: (map['artist'] ?? '') as String,
      hexCode: (map['hexCode'] ?? '') as String,
      songUrl: (map['songUrl'] ?? '') as String,
      thumbnailUrl: (map['thumbnailUrl'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, songName: $songName, artist: $artist, hexCode: $hexCode, songUrl: $songUrl, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.songName == songName &&
        other.artist == artist &&
        other.hexCode == hexCode &&
        other.songUrl == songUrl &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        songName.hashCode ^
        artist.hashCode ^
        hexCode.hashCode ^
        songUrl.hashCode ^
        thumbnailUrl.hashCode;
  }
}
