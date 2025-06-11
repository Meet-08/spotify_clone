import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [hexToColor(currentSong!.hexCode), const Color(0xff121212)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Scaffold(
        backgroundColor: Palette.transparentColor,
        appBar: AppBar(
          backgroundColor: Palette.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              focusColor: Palette.transparentColor,
              highlightColor: Palette.transparentColor,
              splashColor: Palette.transparentColor,
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/pull-down-arrow.png",
                  color: Palette.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: "music-image",
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(currentSong.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Palette.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => songNotifier.playAndPause,
                        icon: const Icon(Icons.favorite),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
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
                        sliderValue =
                            (pos.inMilliseconds / duration.inMilliseconds);
                      }
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              overlayShape: SliderComponentShape.noOverlay,
                            ),
                            child: Slider(
                              value: sliderValue,
                              min: 0,
                              max: 1,
                              onChanged: (val) => sliderValue = val,
                              onChangeEnd: songNotifier.seek,
                              activeColor: Palette.whiteColor,
                              inactiveColor: Palette.whiteColor.withValues(
                                alpha: 0.117,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                formatDuration(pos!),
                                style: const TextStyle(
                                  color: Palette.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Text(
                                formatDuration(duration!),
                                style: const TextStyle(
                                  color: Palette.subtitleText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/shuffle.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/previous-song.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: songNotifier.playAndPause,
                        icon: Icon(
                          songNotifier.isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                        ),
                        iconSize: 80,
                        color: Palette.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/next-song.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/repeat.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/connect-device.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/playlist.png",
                          color: Palette.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
