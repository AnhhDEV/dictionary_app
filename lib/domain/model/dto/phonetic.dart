

import 'license.dart';

class PhoneticDto {
  final String? text;
  final String? audio;
  final String? sourceUrl;
  final LicenseDto? license;

  PhoneticDto({this.text, this.audio, this.sourceUrl, this.license});

  factory PhoneticDto.fromJson(Map<String, dynamic> json) {
    return PhoneticDto(
      text: json['text'],
      audio: json['audio'],
      sourceUrl: json['sourceUrl'],
      license: json['license'] != null
          ? LicenseDto.fromJson(json['license'])
          : null,
    );
  }
}
