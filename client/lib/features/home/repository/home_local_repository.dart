import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box _box = Hive.box("latest_song");

  void uploadLocalSong(SongModel song) {
    if (_box.length > 6) {
      _box.delete(_box.getAt(0));
    }
    _box.put(song.id, song.toJson());
  }

  List<SongModel> loadSong() {
    List<SongModel> songs = [];

    for (final key in _box.keys) {
      songs.add(SongModel.fromJson(_box.get(key)));
    }

    return songs;
  }
}
