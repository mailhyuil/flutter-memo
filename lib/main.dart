import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/features/memo/repositories/memo_repository.dart';
import 'package:memo_app/features/memo/view_models/memo_view_model.dart';
import 'package:memo_app/features/memo/views/memo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final repository = MemoRepository(sp);
  runApp(
    ProviderScope(
      overrides: [
        memoViewModelProvider.overrideWith(() => MemoViewModel(repository))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mail Memo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MemoScreen(),
    );
  }
}
