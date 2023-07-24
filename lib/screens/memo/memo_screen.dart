import 'package:flutter/material.dart';
import 'package:memo_app/widgets/custom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late List<String> memos = [];
  late SharedPreferences sp;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (value) {
        sp = value;
        setState(() {
          memos = sp.getStringList('memos') ?? [];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBarTitle: 'Memo it!',
        body: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  if (value != '') {
                    setState(() {
                      memos.add(value);
                      sp.setStringList('memos', memos);
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                memos[index],
                                softWrap: true,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  memos.removeAt(index);
                                  sp.setStringList('memos', memos);
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
