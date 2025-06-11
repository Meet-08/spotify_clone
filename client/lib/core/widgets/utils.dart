import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickAudio() async {
  try {
    final filePicker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePicker = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }

    return null;
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color) {
  final alpha = ((color.a * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0');
  final red = ((color.r * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0');
  final green = ((color.g * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0');
  final blue = ((color.b * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0');
  return '$alpha$red$green$blue'.toUpperCase();
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16));
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
