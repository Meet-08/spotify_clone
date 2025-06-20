import 'dart:io';
import 'dart:ui';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSong(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return val;
}

@riverpod
Future<List<SongModel>> getAllFavSong(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref
      .watch(homeRepositoryProvider)
      .getAllFavSongs(token: token);

  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return val;
}

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.uploadSong(
      selectedImage: selectedThumbnail,
      selectedAudio: selectedAudio,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
  }

  List<SongModel> getRecentlyPlayedSong() {
    return _homeLocalRepository.loadSong();
  }

  Future<void> favSong({required int songId}) async {
    state = const AsyncValue.loading();

    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
  }
}
