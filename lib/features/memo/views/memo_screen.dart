import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/features/memo/models/memo_model.dart';
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

  void _upsertMemo(MemoModel? memo) {
    _controller.clear();
    if (memo != null) {
      _controller.text = memo.content;
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
                autofocus: true,
                maxLines: 10,
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
                  memo == null
                      ? ref.read(memoViewModelProvider.notifier).addMemo(value)
                      : ref
                          .read(memoViewModelProvider.notifier)
                          .updateMemo(memo.id, value);
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
                  'Simple Memo',
                  textAlign: TextAlign.center,
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
              body: ReorderableListView.builder(
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      final double animValue =
                          Curves.easeInOut.transform(animation.value);
                      final double elevation = lerpDouble(0, 6, animValue)!;
                      return Material(
                        elevation: elevation,
                        color: Colors.white24,
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }
                  ref
                      .read(memoViewModelProvider.notifier)
                      .reorderMemo(oldIndex, newIndex);
                },
                itemCount: memos.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(memos[index].id),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        ref
                            .read(memoViewModelProvider.notifier)
                            .deleteMemo(memos[index].id);
                      }
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const ListTile(
                        trailing: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => ref
                          .read(memoViewModelProvider.notifier)
                          .toggleTrigger(index),
                      child: Column(
                        children: [
                          AnimatedSize(
                            duration: const Duration(seconds: 1),
                            curve: Curves.elasticOut,
                            child: AnimatedContainer(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: memos[index].isCompleted,
                                      onChanged: (value) => ref
                                          .read(memoViewModelProvider.notifier)
                                          .complete(memos[index].id),
                                      activeColor: Colors.green,
                                    ),
                                    Expanded(
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm')
                                                .format(memos[index].createdAt),
                                            softWrap: true,
                                            style: TextStyle(
                                              color: triggers[index]
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w200,
                                            ),
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
                                              _upsertMemo(memos[index]);
                                            },
                                            icon: const Icon(
                                              Icons.edit_document,
                                              color: Colors.black87,
                                            ),
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
                    ),
                  );
                },
              ),
            );
          },
        );
  }
}
