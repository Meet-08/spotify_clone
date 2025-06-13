import 'dart:convert';
import 'dart:io';

import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedImage,
    required File selectedAudio,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final req = http.MultipartRequest(
        "POST",
        Uri.parse("${ServerConstant.baseUrl}/song/upload"),
      );

      req
        ..files.addAll([
          await http.MultipartFile.fromPath("thumbnail", selectedImage.path),
          await http.MultipartFile.fromPath("songFile", selectedAudio.path),
        ])
        ..fields.addAll({
          "songName": songName,
          "artist": artist,
          "hexCode": hexCode,
        })
        ..headers.addAll({"Authorization": "Bearer $token"});

      final res = await req.send();

      if (res.statusCode != 201) {
        return Left(AppFailure("Something went wrong"));
      }

      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.baseUrl}/song/list"),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBodyMap = jsonDecode(res.body) as List;

      if (res.statusCode != 200) {
        return Left(AppFailure("Something went wrong"));
      }

      List<SongModel> songs = [];
      for (var element in resBodyMap) {
        songs.add(SongModel.fromMap(element));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required int songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ServerConstant.baseUrl}/song/favorite"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "song": {"id": songId},
        }),
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        return Left(AppFailure("Something went wrong"));
      }

      return Right(resBodyMap["message"]);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.baseUrl}/song/list/favorite"),
        headers: {"Authorization": "Bearer $token"},
      );

      var resBodyMap = jsonDecode(res.body) as List;

      if (res.statusCode != 200) {
        return Left(AppFailure("Something went wrong"));
      }

      List<SongModel> songs = [];
      for (var element in resBodyMap) {
        songs.add(SongModel.fromMap(element["song"]));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
