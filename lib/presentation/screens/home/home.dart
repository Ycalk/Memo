import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/domain/provider.dart';
import 'package:memo_mind/presentation/components/button_app_bar.dart';
import 'package:memo_mind/presentation/components/masonry_list_view.dart';
import 'package:memo_mind/presentation/components/note_card.dart';
import 'package:memo_mind/presentation/screens/home/new_note.dart';
import 'package:memo_mind/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void pushNoteCreationScreen(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewNotePage()));
  }
  
  @override
  Widget build(BuildContext context) {
    final String? imageUrl = AuthService().currentUser?.photoURL;
    final notes = Provider.of<NoteProvider>(context, listen: true)
      .notes.map((note) => NoteCard(note: note)).toList();

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
      return MasonryListViewGrid(
              key: ValueKey(notes),
              column: Platform.isAndroid || Platform.isIOS ? 2 : 4,
              crossAxisGap: AppSpacings.l,
              mainAxisGap: AppSpacings.l,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.l),
              children: notes
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
        heroTag: 'add',
        shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          onPressed: pushNoteCreationScreen,
          child: const Icon(Icons.add, color: Colors.white, size: AppSpacings.xxl,),
      ),
    );
  }
}