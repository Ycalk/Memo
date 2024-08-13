import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/notes_colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/presentation/components/button_app_bar.dart';
import 'package:memo_mind/presentation/components/masonry_list_view.dart';
import 'package:memo_mind/presentation/components/note_card.dart';
import 'package:memo_mind/presentation/screens/home/new_note.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final notes = List.generate(
                100,
                (index) {
                  final random = Random();
                  final note = Note(
                    title: "Title" * random.nextInt(100),
                    color: NotesColors.colors[random.nextInt(NotesColors.colors.length)],
                  );
                  return NoteCard(note: note);
                },
              );

  void pushNoteCreationScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewNotePage()));
  }
  
  @override
  Widget build(BuildContext context) {
    Widget avatarIcon() => const Icon(Icons.person, size: AppSpacings.xxl,);

    final String? imageUrl = AuthService().currentUser?.photoURL;
    return Scaffold(
      body: Stack(
        children: [
          MasonryListViewGrid(
              key: ValueKey(notes),
              column: Platform.isAndroid || Platform.isIOS ? 2 : 4,
              crossAxisGap: AppSpacings.l,
              mainAxisGap: AppSpacings.l,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.l),
              children: notes
            ),
          ButtonAppBar(
            onPressed: AuthService().signOut,
            heroTag: 'avatar',
            icon: (imageUrl !=null && imageUrl.isNotEmpty) ?
              CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => avatarIcon(),
                errorWidget: (context, url, error) => avatarIcon(),
              ) : avatarIcon()
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: pushNoteCreationScreen,
          child: const Icon(Icons.add, color: Colors.white, size: AppSpacings.xxl,),
      ),
    );
  }
}