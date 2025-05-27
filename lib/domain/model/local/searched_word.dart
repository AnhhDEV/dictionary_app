import 'package:dictionary/domain/model/local/cache_word.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'searched_word.g.dart';

@HiveType(typeId: 2)
class SearchedWord {
  @HiveField(0)
  final int keyWord;
  @HiveField(1)
  final String searchTime;

  SearchedWord(this.keyWord, this.searchTime);
}