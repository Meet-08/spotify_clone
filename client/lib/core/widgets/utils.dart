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
  final red = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
  final green = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
  final blue = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
  return "$red$blue$green";
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
