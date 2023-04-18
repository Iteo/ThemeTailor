import 'package:theme_tailor/src/model/constructor_parameter_type.dart';
import 'package:theme_tailor/src/template/template.dart';

class ClassInstanceTemplate extends Template {
  ClassInstanceTemplate({
    required this.constructorName,
    required this.fieldNameToValue,
    this.fieldNameToParamType,
  });

  final String constructorName;
  final Map<String, CtorParamType>? fieldNameToParamType;
  final Iterable<MapEntry<String, String>> fieldNameToValue;

  @override
  void write(StringBuffer buffer) {
    if (fieldNameToParamType == null) return writeAllAsNamedParams(buffer);

    final inRequired = <String>{};
    final inNamed = <String>{};
    final inOptional = <String>{};

    for (final field in fieldNameToValue) {
      fieldNameToParamType![field.key]?.when(
        onRequired: () => inRequired.add('${field.value},'),
        onNamed: () => inNamed.add('${field.key}: ${field.value},'),
        onOptional: () => inOptional.add('${field.value},'),
      );
    }

    buffer
      ..writeln(constructorName)
      ..write('(')
      ..writeAll(inRequired)
      ..writeAll(inNamed.isNotEmpty ? inNamed : inOptional)
      ..write(')');
  }

  void writeAllAsNamedParams(StringBuffer buffer) {
    buffer
      ..writeln(constructorName)
      ..write('(')
      ..writeAll(fieldNameToValue.map((e) => '${e.key}: ${e.value},'))
      ..writeln(')');
  }
}
