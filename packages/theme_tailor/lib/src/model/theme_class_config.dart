import 'package:theme_tailor/src/model/annotation_data_manager.dart';
import 'package:theme_tailor/src/model/field.dart';
import 'package:theme_tailor/src/model/theme_encoder_data.dart';
import 'package:theme_tailor/src/model/theme_getter_data.dart';

class ThemeClassConfig {
  const ThemeClassConfig({
    required this.fields,
    required this.themes,
    required this.baseClassName,
    required this.className,
    required this.encoderManager,
    required this.themeGetter,
    required this.annotationManager,
    required this.isFlutterDiagnosticable,
  });

  final Map<String, Field> fields;
  final List<String> themes;
  final String baseClassName;
  final String className;
  final ThemeEncoderDataManager encoderManager;
  final ExtensionData themeGetter;
  final AnnotationDataManager annotationManager;
  final bool isFlutterDiagnosticable;
}
