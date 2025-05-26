class WordScoreDto {
  final String word;
  final int score;

  WordScoreDto({required this.word, required this.score});

  factory WordScoreDto.fromJson(Map<String, dynamic> json) {
    return WordScoreDto(
      word: json['word'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'score': score,
    };
  }
}
