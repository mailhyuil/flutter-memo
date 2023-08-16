import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app/features/memo/models/memo_model.dart';
import 'package:memo_app/features/memo/repositories/memo_repository.dart';

class MemoViewModel extends AsyncNotifier<List<MemoModel>> {
  late final MemoRepository repo;
  List<MemoModel> memos = [];
  List<bool> triggers = [];
  MemoViewModel(this.repo);

  @override
  FutureOr<List<MemoModel>> build() async {
    final jsonStrings = await repo.getMemos();
    final json = jsonStrings.map((e) => jsonDecode(e));
    final res = json.map((e) => MemoModel.fromJson(e)).toList();
    memos.addAll(res);
    _initTriggers();
    return memos;
  }

  void _initTriggers() {
    triggers = List.generate(memos.length, (index) => false);
  }

  void toggleTrigger(int index) {
    triggers[index] = !triggers[index];
    state = AsyncValue.data([...memos]);
  }

  void reorderMemo(int oldIndex, int newIndex) async {
    final memo = memos.removeAt(oldIndex);
    memos.insert(newIndex, memo);
    state = AsyncValue.data([...memos]);
  }

  void complete(String id) {
    final index = findIndexById(id);
    final memo = memos[index];
    final completedMemo = MemoModel(
      content: memo.content,
      createdAt: memo.createdAt,
      isCompleted: !memo.isCompleted,
    );
    memos[index] = completedMemo;
    repo.updateMemo(index, jsonEncode(completedMemo.toJson()));
    state = AsyncValue.data([...memos]);
  }

  int findIndexById(String id) {
    return memos.indexWhere((element) => element.id == id);
  }

  void addMemo(String memo) async {
    final newMemo = MemoModel(content: memo, createdAt: DateTime.now());
    await repo.addMemo(jsonEncode(newMemo.toJson()));
    memos = [newMemo, ...memos];
    _initTriggers();
    state = AsyncValue.data(memos);
  }

  void deleteMemo(String id) async {
    final index = findIndexById(id);
    memos.removeAt(index);
    await repo.deleteMemo(index);
    _initTriggers();
    state = AsyncValue.data([...memos]);
  }

  void updateMemo(String id, String memo) async {
    final index = findIndexById(id);
    final newMemo = MemoModel(content: memo, createdAt: DateTime.now());
    memos[index] = newMemo;
    await repo.updateMemo(index, jsonEncode(newMemo.toJson()));
    _initTriggers();
    state = AsyncValue.data([...memos]);
  }
}

final memoViewModelProvider =
    AsyncNotifierProvider<MemoViewModel, List<MemoModel>>(
  () => throw UnimplementedError(),
);
