import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/features/memo/view_models/memo_view_model.dart';

class MemoScreen extends ConsumerStatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);
  @override
  MemoScreenState createState() => MemoScreenState();
}

class MemoScreenState extends ConsumerState<MemoScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController();

  BuildContext? dialogContext;

  void _upsertMemo(int? index) {
    _controller.clear();
    if (index != null) {
      _controller.text =
          ref.read(memoViewModelProvider).asData!.value[index].content;
    }
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
                onFieldSubmitted: (value) {
                  if (value == '') return;
                  Navigator.pop(dialogContext!);
                  index == null
                      ? ref.read(memoViewModelProvider.notifier).addMemo(value)
                      : ref
                          .read(memoViewModelProvider.notifier)
                          .updateMemo(index, value);
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(memoViewModelProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, s) => const Center(
            child: Text('Error'),
          ),
          data: (memos) {
            final triggers = ref.read(memoViewModelProvider.notifier).triggers;
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
                onPressed: () => _upsertMemo(null),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: memos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(memoViewModelProvider.notifier)
                                .toggleTrigger(index);
                            // _upsertMemo(index);
                          },
                          child: Column(
                            children: [
                              AnimatedSize(
                                duration: const Duration(seconds: 1),
                                curve: Curves.elasticOut,
                                child: AnimatedContainer(
                                  height: triggers[index] ? 200 : null,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.elasticOut,
                                  decoration: BoxDecoration(
                                    color: triggers[index]
                                        ? Colors.white
                                        : Colors.white10,
                                    borderRadius: triggers[index]
                                        ? BorderRadius.circular(20)
                                        : BorderRadius.circular(0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                memos[index].content,
                                                softWrap: true,
                                                style: TextStyle(
                                                    overflow: triggers[index]
                                                        ? null
                                                        : TextOverflow.ellipsis,
                                                    color: triggers[index]
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(
                                                        memos[index].createdAt),
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: triggers[index]
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: triggers[index],
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  _upsertMemo(index);
                                                },
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.black),
                                              ),
                                              IconButton(
                                                onPressed: () => ref
                                                    .read(memoViewModelProvider
                                                        .notifier)
                                                    .deleteMemo(index),
                                                icon: const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}
