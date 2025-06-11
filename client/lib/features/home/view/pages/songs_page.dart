import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSong = ref
        .watch(homeViewmodelProvider.notifier)
        .getRecentlyPlayedSong();

    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        gradient: currentSong == null
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hexToColor(currentSong.hexCode),
                  Palette.transparentColor,
                ],
                stops: const [0.0, 0.3],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 36),
            child: SizedBox(
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: recentlyPlayedSong.length,
                itemBuilder: (context, index) {
                  final song = recentlyPlayedSong[index];
                  return Container(
                    padding: const EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                      color: Palette.borderColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song);
                      },
                      child: Row(
                        spacing: 8,
                        children: [
                          Container(
                            width: 56,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(song.thumbnailUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              song.songName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Latest today",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref
              .watch(getAllSongProvider)
              .when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return GestureDetector(
                          onTap: () => ref
                              .read(currentSongNotifierProvider.notifier)
                              .updateSong(song),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnailUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.songName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      color: Palette.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) => Center(child: Text(error.toString())),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
