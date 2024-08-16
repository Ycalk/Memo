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
import 'package:popup_menu_plus/popup_menu_plus.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<Note> _selected = {};
  final GlobalKey _avatarKey = GlobalKey();

  void showMenu(){
    PopupMenu menu = PopupMenu(
      context: context,
      config: MenuConfig.forList(
        borderRadius: BorderRadius.circular(AppSpacings.l),
        backgroundColor: AppColors.primary,
        itemWidth: 230,
        itemHeight: 50,
        arrowHeight: AppSpacings.m,
        lineColor: Colors.white,
        highlightColor: Colors.white,
      ),
      items: [
        PopUpMenuItem.forList(
            textStyle: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
            title: 'Log out',
            image: const Icon(Icons.logout, color: Colors.white, size: AppSpacings.xxl + 5)),
        
        if (AuthService().currentUser!.isAnonymous) 
          PopUpMenuItem.forList(
              textStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
              title: 'Google account',
              image: const Icon(Icons.add, color: Colors.white, size: AppSpacings.xxl + 5)),
      ],
      onClickMenu: (item) {
        if (item.menuTitle == 'Log out'){
          AuthService().signOut();
        } else if (item.menuTitle == 'Google account'){
          AuthService().linkGoogleAccount();
        }
      },
    );
    menu.show(widgetKey: _avatarKey);
  }

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
    var counter = 0;
    final notesInfo = Provider.of<NoteProvider>(context, listen: true).notes.toList();
    notesInfo.sort((a, b) => -(a.created.compareTo(b.created)));
      
    final notes = notesInfo.map((note) {
        final noteCard = NoteCard(
        key: ValueKey(note.id + counter.toString()),
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
        );
        counter++;
        return noteCard;
      }).toList();

    
    

    Widget avatarIcon() => const Icon(Icons.person, size: AppSpacings.xxl, color: Colors.white);
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
        padding: const EdgeInsets.all(AppSpacings.m),
        crossAxisCount: Platform.isAndroid || Platform.isIOS ? 2 : 4,
        mainAxisSpacing: AppSpacings.m,
        crossAxisSpacing: AppSpacings.m,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return notes[index]
              .animate()
              .fadeIn(delay: 100.ms * (index), curve: Curves.easeIn)
              .moveY(delay: 100.ms * (index), curve: Curves.easeIn);
        },
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          getNotes(),
          
          ButtonAppBar(
            alignment: Alignment.bottomLeft,
            heroTag: 'avatar',
            icon: MaterialButton(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
              key: _avatarKey,
              onPressed: showMenu,
              child: SizedBox.expand(
                child: (imageUrl !=null && imageUrl.isNotEmpty) ?
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
                  ) : avatarIcon(),
              ),
              
            ),
          )
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