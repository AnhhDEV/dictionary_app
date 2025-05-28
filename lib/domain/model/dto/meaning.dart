import 'package:dictionary/domain/model/local/cache_meaning.dart';

import 'definition.dart';

class MeaningDto {
  final String partOfSpeech; //loại từ
  final List<DefinitionDto> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  MeaningDto({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory MeaningDto.fromJson(Map<String, dynamic> json) {
    return MeaningDto(
      partOfSpeech: json['partOfSpeech'],
      definitions:
          (json['definitions'] as List<dynamic>)
              .map((e) => DefinitionDto.fromJson(e))
              .toList(),
      synonyms: List<String>.from(json['synonyms'] ?? []),
      antonyms: List<String>.from(json['antonyms'] ?? []),
    );
  }
}

extension Converter on MeaningDto {
  CacheMeaning toCacheMeaning() {
    return CacheMeaning(
      partOfSpeech: partOfSpeech,
      definitions: definitions.map((e) => e.definition).toList(),
      synonyms: synonyms,
      antonyms: antonyms,
    );
  }
}
