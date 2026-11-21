import 'package:flutter/material.dart';

import '../../core/enums/app_enums.dart';

class Team {
  final String id;
  final String name;
  final String shortName;
  final String abbreviation;
  final String flag;
  final String primaryColor;
  final String secondaryColor;
  final bool international;
  final String city;
  final String founded;

  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.abbreviation,
    required this.flag,
    required this.primaryColor,
    this.secondaryColor = '#FFFFFF',
    this.international = true,
    this.city = '',
    this.founded = '',
  });

  Color get color => Color(int.parse(primaryColor.replaceFirst('#', '0xFF')));

  Color get accent => Color(int.parse(secondaryColor.replaceFirst('#', '0xFF')));

  Team copyWith({String? name, String? shortName}) => Team(
        id: id,
        name: name ?? this.name,
        shortName: shortName ?? this.shortName,
        abbreviation: abbreviation,
        flag: flag,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        international: international,
        city: city,
        founded: founded,
      );
}

class SquadGroup {
  final PlayerRole role;
  final List<String> playerIds;

  const SquadGroup({required this.role, required this.playerIds});
}
