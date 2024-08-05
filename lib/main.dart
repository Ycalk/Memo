import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memo_mind/config/constants.dart';
import 'package:memo_mind/domain/provider.dart';
import 'package:memo_mind/config/theme/theme.dart';
import 'package:memo_mind/services/firebase_options.dart';
import 'package:memo_mind/services/auth/auth_gate.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        title: StringConstants.projectName,
        scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
        home: const AuthGate(),
      ),
    );
  }
}

