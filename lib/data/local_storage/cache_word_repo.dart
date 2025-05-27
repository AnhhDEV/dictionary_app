import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CacheWordRepository {
  final Box<CacheWord> _box;

  CacheWordRepository(this._box);

  Future<void> add(CacheWord word) async {
    final exists = _box.values.any((w) => w.word == word.word);
    if (!exists) {
      await _box.add(word);
    }
  }

  CacheWord? getByWord(String word) {
    try {
      return _box.values.firstWhere((w) => w.word == word);
    } catch (_) {
      return null;
    }
  }

  CacheWord? getByKey(int key) {
    return _box.get(key);
  }
  
  int? getKeyByWord(String word) {
    try {
      return _box.keys
          .cast<int>()
          .firstWhere((key) => _box.get(key)?.word == word);
    } catch(e) {
      return null;
    }
  }

  List<CacheWord> getAll() => _box.values.toList();

}
