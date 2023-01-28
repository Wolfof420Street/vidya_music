import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vidya_music/controller/cubit/audio_player_cubit.dart';
import 'package:vidya_music/controller/cubit/roster_cubit.dart';
import 'package:vidya_music/view/track_item.dart';

class RosterList extends StatefulWidget {
  const RosterList({super.key});

  @override
  State<RosterList> createState() => _RosterListState();
}

class _RosterListState extends State<RosterList> {
  int? scrollPosition;

  void scrollToTrack(int? index) {
    if (index == null || index == scrollPosition) return;
    scrollPosition = index;

    itemScrollController.scrollTo(
        index: index, duration: const Duration(milliseconds: 300));
  }

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();

    return BlocListener<AudioPlayerCubit, AudioPlayerState>(
      listener: (context, aps) {
        scrollToTrack(aps.currentTrackIndex);
      },
      child: BlocBuilder<RosterCubit, RosterState>(
        builder: (context, roster) {
          if (roster is RosterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (roster is RosterSuccess) {
            final ros = roster.roster;
            BlocProvider.of<AudioPlayerCubit>(context, listen: false)
                .initializePlayer(ros);
            return ScrollablePositionedList.separated(
              itemCount: ros.tracks.length,
              itemBuilder: (context, i) {
                return TrackItem(track: ros.tracks[i], index: i);
              },
              separatorBuilder: (context, i) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(height: 2.0, thickness: 0.0),
              ),
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Couldn't fetch tracks"),
                ElevatedButton(
                    child: const Text('Try again'),
                    onPressed: () {
                      BlocProvider.of<RosterCubit>(context, listen: false)
                          .fetchRoster();
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
