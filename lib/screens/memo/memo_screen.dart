import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memo_app/widgets/custom_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late SharedPreferences sp;
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController();
  late List<String> memos = [];
  late final List<bool> _triggers = memos.map((e) => false).toList();
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

  void _onFieldSubmitted(String value) {
    if (value != '') {
      setState(() {
        memos.add(value);
        _triggers.add(false);
        sp.setStringList('memos', memos);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBarTitle: 'Mail Memo',
        body: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter your memo',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
                onFieldSubmitted: _onFieldSubmitted,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _triggers[index] = true;
                          });
                        },
                        child: AnimatedSize(
                          duration: const Duration(seconds: 1),
                          curve: Curves.elasticOut,
                          child: AnimatedContainer(
                            onEnd: () {
                              Timer(const Duration(seconds: 2), () {
                                setState(() {
                                  _triggers[index] = false;
                                });
                              });
                            },
                            height: _triggers[index] ? 400 : null,
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticOut,
                            decoration: BoxDecoration(
                              color: _triggers[index]
                                  ? Colors.lightBlue[900]
                                  : Colors.white,
                              borderRadius: _triggers[index]
                                  ? BorderRadius.circular(30)
                                  : BorderRadius.circular(0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      memos[index],
                                      softWrap: true,
                                      style: TextStyle(
                                          color: _triggers[index]
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        memos.removeAt(index);
                                        sp.setStringList('memos', memos);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: _triggers[index]
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
