import 'dart:developer';

import 'package:dictionary/domain/model/dto/phonetic.dart';
import 'package:dictionary/util/string_handle.dart';

import '../local/cache_meaning.dart';
import '../local/cache_word.dart';
import 'meaning.dart';

class WordDto {
  final String word;
  final String? phonetic;
  final List<PhoneticDto> phonetics;
  final List<MeaningDto> meanings;

  WordDto({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory WordDto.fromJson(Map<String, dynamic> json) {
    return WordDto(
      word: json['word'],
      phonetic: json['phonetic'],
      phonetics:
          (json['phonetics'] as List<dynamic>)
              .map((e) => PhoneticDto.fromJson(e))
              .toList(),
      meanings:
          (json['meanings'] as List<dynamic>)
              .map((e) => MeaningDto.fromJson(e))
              .toList(),
    );
  }
}

extension WordExtension on WordDto {
  String getAllPartOfSpeeches() {
    final posSet = <String>{};
    for (var meaning in meanings) {
      var currentPOS = StringHandle.getFirstPoS(meaning.partOfSpeech);
      posSet.add(currentPOS);
    }
    final result = posSet.join(', ');
    log('Part of Speech: $result');
    return "($result)";
  }

  String getPhonetic() {
    if (phonetic != null && phonetic!.trim().isNotEmpty) {
      return phonetic!;
    }
    for (final p in phonetics) {
      if (p.text != null && p.text!.trim().isNotEmpty && p.license != null) {
        return p.text!;
      }
    }
    return "";
  }

  String? getUrlAudio() {
    for (final p in phonetics) {
      if (p.license != null && p.audio != null && p.audio!.isNotEmpty) {
        return p.audio;
      }
    }
    for (final p in phonetics) {
      if (p.audio != null && p.audio!.isNotEmpty) {
        return p.audio;
      }
    }
    return null;
  }
}

CacheWord convertToCacheWord(WordDto dto) {
  final phonetic = dto.getPhonetic();

  final audio = dto.getUrlAudio();

  final meanings = dto.meanings.map((m) {
    return CacheMeaning(
      partOfSpeech: m.partOfSpeech,
      definitions: m.definitions.map((d) => d.definition).toList(),
      synonyms: m.synonyms,
      antonyms: m.antonyms,
    );
  }).toList();

  return CacheWord(
    dto.word,
    phonetic,
    null,
    audio,
    meanings,
    false
  );
}