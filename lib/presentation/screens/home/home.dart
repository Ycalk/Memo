import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/presentation/components/home_app_bar.dart';
import 'package:memo_mind/presentation/components/masonry_list_view.dart';
import 'package:memo_mind/presentation/components/note_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _scrollOffset = 0.0;
  final notes = List.generate(
                100,
                (index) => NoteCard(note: Note(
                  title: "Title" * index,
                )
              ),
            );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              Future.delayed(Duration.zero, () => setState(() => _scrollOffset = notification.metrics.pixels));
              return true;
            },
            child: MasonryListViewGrid(
              key: ValueKey(notes),
              column: 2,
              crossAxisGap: AppSpacings.l,
              mainAxisGap: AppSpacings.l,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl),
              children: notes
            ),
          ),
          HomeAppBar(scrollOffset: _scrollOffset,)
        ],
      )
    );
  }
}