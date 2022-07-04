import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'themes_name_collision.tailor.dart';

@tailor
class $_SimpleTheme {
  static List<AnotherTheme> anotherTheme = AnotherTheme.tailorThemes;
}

@tailor
class $_AnotherTheme {
  static List<Color> themes = [Colors.amber, Colors.blueGrey.shade800];
}
