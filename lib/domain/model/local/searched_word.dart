import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class SearchedWord {
  @HiveField(0)
  final CacheWord word;
  @HiveField(1)
  final String searchTime;

  SearchedWord(this.word, this.searchTime);
}