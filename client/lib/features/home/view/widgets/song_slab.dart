import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongSlab extends ConsumerWidget {
  const SongSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);

    if (currentSong == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MusicPlayer(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeIn));

            final offSetAnimation = animation.drive(tween);
            return SlideTransition(position: offSetAnimation, child: child);
          },
        ),
      ),
      child: Stack(
        children: [
          Hero(
            tag: "music-image",
            child: Container(
              height: 66,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: hexToColor(currentSong.hexCode),
              ),

              padding: const EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Palette.subtitleText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(homeViewmodelProvider.notifier)
                              .favSong(songId: currentSong.id);
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playAndPause,
                        icon: Icon(
                          songNotifier.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final pos = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              double sliderValue = 0;
              if (pos != null && duration != null) {
                sliderValue = (pos.inMilliseconds / duration.inMilliseconds);
              }

              return Positioned(
                bottom: 0,
                left: 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 11),
                  decoration: BoxDecoration(
                    color: Palette.whiteColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: (MediaQuery.of(context).size.width - 11),
              decoration: BoxDecoration(
                color: Palette.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
