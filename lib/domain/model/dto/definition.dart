class DefinitionDto {
  final String definition;
  final String? example;

  DefinitionDto({
    required this.definition,
    this.example,

  });

  factory DefinitionDto.fromJson(Map<String, dynamic> json) {
    return DefinitionDto(
      definition: json['definition'],
      example: json['example']
    );
  }
}
