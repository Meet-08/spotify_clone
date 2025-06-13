import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getAllFavSongProvider)
        .when(
          data: (songs) => ListView.builder(
            itemCount: songs.length + 1,
            itemBuilder: (context, index) {
              if (index == songs.length) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UploadSongPage(),
                    ),
                  ),
                  leading: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Palette.backgroundColor,
                    child: Icon(CupertinoIcons.plus),
                  ),
                  title: const Text(
                    "Upload New Song",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                );
              }
              final song = songs[index];
              return ListTile(
                onTap: () => ref
                    .read(currentSongNotifierProvider.notifier)
                    .updateSong(song),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(song.thumbnailUrl),
                  radius: 35,
                  backgroundColor: Palette.backgroundColor,
                ),
                title: Text(
                  song.songName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          error: (er, st) => Center(child: Text(er.toString())),
          loading: () => const Loader(),
        );
  }
}
