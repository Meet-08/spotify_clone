import 'dart:convert';
import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ServerConstant.baseUrl}/auth/signup"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 201) return Left(AppFailure(resBodyMap["message"]));
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signin({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${ServerConstant.baseUrl}/auth/signin"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final resBodyMap = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 200) return Left(AppFailure(resBodyMap["message"]));
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
