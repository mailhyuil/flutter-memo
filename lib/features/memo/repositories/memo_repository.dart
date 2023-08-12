import 'package:shared_preferences/shared_preferences.dart';

class MemoRepository {
  final SharedPreferences sp;

  MemoRepository(this.sp);

  Future<List<String>> getMemos() async {
    return sp.getStringList('memos') ?? [];
  }

  Future<String> getMemo(int index) async {
    final memos = await getMemos();
    return memos[index];
  }

  Future<void> addMemo(String memo) async {
    final memos = await getMemos();
    memos.add(memo);
    sp.setStringList('memos', memos);
  }

  Future<void> deleteMemo(int index) async {
    final memos = await getMemos();
    memos.removeAt(index);
    sp.setStringList('memos', memos);
  }

  Future<void> updateMemo(int index, String memo) async {
    final memos = await getMemos();
    memos[index] = memo;
    sp.setStringList('memos', memos);
  }
}
