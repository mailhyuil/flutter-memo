import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  BuildContext? dialogContext;
  void _onFieldSubmitted(String value) {
    if (value != '') {
      setState(() {
        memos.add(value);
        _triggers.add(false);
        sp.setStringList('memos', memos);
        _controller.clear();
      });
      Navigator.pop(dialogContext!);
      dialogContext = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(
            'Mail Memo',
            style: GoogleFonts.pacifico(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    dialogContext = context;
                    return Dialog(
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          controller: _controller,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter your memo',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          onFieldSubmitted: _onFieldSubmitted,
                        ),
                      ),
                    );
                  });
            },
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            )),
        body: Column(
          children: [
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
                            _triggers[index] = !_triggers[index];
                          });
                        },
                        child: AnimatedSize(
                          duration: const Duration(seconds: 1),
                          curve: Curves.elasticOut,
                          child: AnimatedContainer(
                            height: _triggers[index] ? 400 : null,
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticOut,
                            decoration: BoxDecoration(
                              color: _triggers[index]
                                  ? Colors.white
                                  : Colors.white10,
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
                                              ? Colors.black
                                              : Colors.white,
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
                                      Icons.check_circle,
                                      color: _triggers[index]
                                          ? Colors.black
                                          : Colors.white,
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
