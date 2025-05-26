class LicenseDto {
  final String name;
  final String url;

  LicenseDto({
    required this.name,
    required this.url,
  });

  factory LicenseDto.fromJson(Map<String, dynamic> json) {
    return LicenseDto(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
