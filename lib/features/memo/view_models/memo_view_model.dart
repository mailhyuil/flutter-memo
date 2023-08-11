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

  void addMemo(String memo) async {
    final newMemo = MemoModel(content: memo, createdAt: DateTime.now());
    await repo.addMemo(jsonEncode(newMemo.toJson()));
    memos = [...memos, newMemo];
    _initTriggers();
    state = AsyncValue.data(memos);
  }

  void deleteMemo(int index) async {
    memos.removeAt(index);
    await repo.deleteMemo(index);
    _initTriggers();
    state = AsyncValue.data([...memos]);
  }

  void updateMemo(int index, String memo) async {
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
