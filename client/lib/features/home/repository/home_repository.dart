import 'dart:io';

import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
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
      print("This is called");
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
}
