import 'package:flutter/material.dart';
import 'package:memo_mind/common/constants.dart';
import 'package:memo_mind/common/provider.dart';
import 'package:memo_mind/common/theme/theme.dart';
import 'package:memo_mind/screens/route.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
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
        home: const RoutePage(),
      ),
    );
  }
}

