import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'cache_meaning.g.dart';

@HiveType(typeId: 0)
class CacheMeaning {

  @HiveField(0)
  final String partOfSpeech;
  @HiveField(1)
  final List<String> definitions;
  @HiveField(2)
  final List<String> synonyms;
  @HiveField(3)
  final List<String> antonyms;

  CacheMeaning({required this.partOfSpeech, required this.definitions, required this.synonyms, required this.antonyms});
}