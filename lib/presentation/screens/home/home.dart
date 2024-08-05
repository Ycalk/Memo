import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/colors.dart';
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

  final notes = List.generate(
                100,
                (index) => NoteCard(note: Note(
                  title: "Title" * index,
                )
              ),
            );

  void pushNoteCreationScreen(){

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MasonryListViewGrid(
              key: ValueKey(notes),
              column: 2,
              crossAxisGap: AppSpacings.l,
              mainAxisGap: AppSpacings.l,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.xl),
              children: notes
            ),
          const HomeAppBar()
        ],
      ),
      floatingActionButton: Container(
        width: AppSpacings.xxl * 2,
        height: AppSpacings.xxl * 2,
        child: FittedBox(
          child: FloatingActionButton(
            shape: CircleBorder(),
              backgroundColor: AppColors.primary,
              onPressed: pushNoteCreationScreen,
              child: const Icon(Icons.add, color: Colors.white, size: 25),
          ),
        ),
      ),
    );
  }
}