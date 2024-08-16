import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/note.dart';
import 'package:memo_mind/domain/provider.dart';
import 'package:memo_mind/presentation/components/button_app_bar.dart';
import 'package:memo_mind/presentation/components/note_card.dart';
import 'package:memo_mind/presentation/screens/home/note.dart';
import 'package:memo_mind/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<Note> _selected = {};

  void markAsSelected(Note note){
    setState(() {
      _selected.add(note);
    });
  }
  void unselect(Note note){
    setState(() {
      _selected.remove(note);
    });
  }

  void pushNoteCreationScreen({Note? note}){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotePage(note: note,)));
  }
  
  void deleteSelected(){
    final provider = Provider.of<NoteProvider>(context, listen: false);
    for (var note in _selected) {
      provider.database.removeNote(note);
    }
    setState(() {
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = AuthService().currentUser?.photoURL;
    final notes = Provider.of<NoteProvider>(context, listen: true)
      .notes.map((note) => NoteCard(
        selected: _selected.contains(note),
        note: note,
        onTap: () {
          if (_selected.isEmpty){
            pushNoteCreationScreen(note: note);
            return;
          }
          if (_selected.contains(note)){
            unselect(note);
          } else {
            markAsSelected(note);
          }
        },
        onSelect: () => markAsSelected(note),
      )
      ).toList();

    notes.sort((a, b) => -(a.note.created.compareTo(b.note.created)));

    Widget avatarIcon() => const Icon(Icons.person, size: AppSpacings.xxl,);
    Widget getNotes(){
      if (notes.isEmpty){
        return Center(
          child: Text('No notes yet', style: GoogleFonts.montserrat(
            color: AppColors.description,
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),),
        );
      }
      return MasonryGridView.count(
        crossAxisCount: Platform.isAndroid || Platform.isIOS ? 2 : 4,
        mainAxisSpacing: AppSpacings.m,
        crossAxisSpacing: AppSpacings.m,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return notes[index];
        },
      );
    }

    
    return Scaffold(
      body: Stack(
        children: [
          getNotes(),
          
          ButtonAppBar(
            alignment: Alignment.bottomLeft,
            onPressed: AuthService().signOut,
            heroTag: 'avatar',
            icon: (imageUrl !=null && imageUrl.isNotEmpty) ?
              CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 100),
                imageUrl: imageUrl,
                placeholder: (context, url) => avatarIcon(),
                errorWidget: (context, url, error) => avatarIcon(),
              ) : avatarIcon()
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: ValueKey<bool>(_selected.isEmpty),
        heroTag: 'action',
        shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: _selected.isEmpty ? pushNoteCreationScreen : deleteSelected,
          child: Icon(
            _selected.isEmpty ? Icons.add : Icons.delete_rounded, 
            color: Colors.white, 
            size: AppSpacings.xxl,
          ).animate().fadeIn(duration: 200.ms),
      )
    );
  }
}