import 'package:flutter/material.dart';
import 'package:memo_app/screens/memo/memo_screen.dart';
import 'package:memo_app/widgets/custom_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Welcome!',
      body: Center(
        child: Column(
          children: [
            const Expanded(child: Center(child: Text("Let's Memo!"))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MemoScreen();
                        },
                      ),
                    );
                  },
                  child: const Text('Click me!'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
