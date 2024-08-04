import 'package:flutter/material.dart';
import 'package:memo_mind/config/theme/colors.dart';
import 'package:memo_mind/config/theme/spacing.dart';
import 'package:memo_mind/services/auth/auth_service.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.scrollOffset});

  final double scrollOffset;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  static const double reachingOffset = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.scrollOffset < 10) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant HomeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final scrollOffset = widget.scrollOffset - oldWidget.scrollOffset;
    if (widget.scrollOffset < 10) {
      _animationController.forward();
    } else if (scrollOffset > reachingOffset) {
      _animationController.reverse();
    } else if (scrollOffset < -reachingOffset) {
      _animationController.forward();
    }
  }
  CircleAvatar getAvatar(){
    final String? imageUrl = AuthService().currentUser?.photoURL;
    if (imageUrl !=null && imageUrl.isNotEmpty ) {
      return CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 23,
        );
    }
    return const CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: 23,
      child: Icon(Icons.person, size: 23,),
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return SlideTransition(
      position: _animation,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: AppSpacings.xl, left: AppSpacings.l),
          child: GestureDetector(
            onTap: AuthService().signOut,
            child: getAvatar(),
          ) 
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
