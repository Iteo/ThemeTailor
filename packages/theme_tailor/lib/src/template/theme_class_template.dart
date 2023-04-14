import 'package:collection/collection.dart';
import 'package:theme_tailor/src/model/field.dart';
import 'package:theme_tailor/src/model/theme_class_config.dart';
import 'package:theme_tailor/src/template/theme_extension/copy_with_template.dart';
import 'package:theme_tailor/src/util/string_format.dart';

class ThemeTailorTemplate {
  const ThemeTailorTemplate(this.config, this.fmt);

  final ThemeClassConfig config;
  final StringFormat fmt;

  String _classTypesDeclaration() {
    final mixins = [
      if (config.hasDiagnosticableMixin) 'DiagnosticableTreeMixin'
    ];
    final mixinsString = mixins.isEmpty ? '' : ' with ${mixins.join(',')}';

    return 'extends ThemeExtension<${config.className}>$mixinsString';
  }

  String _constructorAndParams() {
    final constructorBuffer = StringBuffer();
    final fieldsBuffer = StringBuffer();

    config.fields.forEach((key, value) {
      if (!value.isNullable) {
        constructorBuffer.write('required ');
      }
      constructorBuffer.write('this.$key,');
      fieldsBuffer
        ..write(config.annotationManager.expandFieldAnnotations(key))
        ..write(
          value.documentation != null ? '${value.documentation}\n' : '',
        )
        ..write('final ${value.type} $key;');
    });

    if (config.fields.isEmpty) {
      return '''
      const ${config.className}();
    
      ${fieldsBuffer.toString()}
    ''';
    } else {
      return '''
      const ${config.className}({
        ${constructorBuffer.toString()}
      });
    
      ${fieldsBuffer.toString()}
    ''';
    }
  }

  /// Generate all of the themes
  String _generateThemes() {
    if (config.themes.isEmpty) return '';
    final buffer = StringBuffer();
    if (config.staticGetters && !config.constantThemes) {
      config.themes.forEachIndexed((_, e) {
        buffer.write(_getterTemplate(e));
      });
    }
    config.themes.forEachIndexed((i, e) {
      buffer.write(_themeTemplate(i, e));
    });
    final themesList = config.themes.fold('', (p, theme) => '$p$theme,');
    buffer.writeln(
        'static ${_themeModifier()} ${config.themesFieldName} = [$themesList];');
    return buffer.toString();
  }

  /// Template for one static getter
  String _getterTemplate(String themeName) {
    final returnType = config.className;

    return '''static $returnType get $themeName => kDebugMode ? _${themeName}Getter : _${themeName}Final;
    \n''';
  }

  /// Template for one static theme
  String _themeTemplate(int index, String themeName) {
    final buffer = StringBuffer();
    final returnType = config.className;

    for (final field in config.fields.entries) {
      final values = field.value.values;
      if (values != null) {
        buffer.write('${field.key}: ${values[index]},');
      } else {
        buffer.write(
            '${field.key}: ${config.baseClassName}.${field.key}[$index],');
      }
    }

    if (config.constantThemes || !config.staticGetters) {
      return '''
    static ${_themeModifier()} $returnType $themeName = $returnType(
      ${buffer.toString()}
    );\n
    ''';
    }
    return '''
    static $returnType get _${themeName}Getter => $returnType(
      ${buffer.toString()}
    );\n    
    static final $returnType _${themeName}Final = $returnType(
      ${buffer.toString()}
    );\n
    ''';
  }

  String _lerpMethod() {
    final returnType = config.className;
    final classParams = StringBuffer();
    config.fields.forEach((key, value) {
      if (value.isThemeExtension) {
        classParams.write(
            '$key: $key${value.isNullable ? '?' : ''}.lerp(other.$key, t),');
      } else {
        classParams.write(
            '$key: ${config.encoderManager.encoderFromField(value.name, value.type).callLerp(key, 'other.$key', 't')},');
      }
    });

    return '''
    @override
    $returnType lerp(ThemeExtension<$returnType>? other, double t) {
      if (other is! $returnType) return this;
      return $returnType(
        ${classParams.toString()}
      );
    }
    ''';
  }

  String _fromJsonFactory() {
    if (!config.hasJsonSerializable) return '';
    return '''factory ${config.className}.fromJson(Map<String, dynamic> json) =>
      _\$${config.className}FromJson(json);\n''';
  }

  String _debugFillPropertiesMethod() {
    if (!config.hasDiagnosticableMixin) return '';

    final diagnostics = [
      for (final e in config.fields.entries)
        "..add(DiagnosticsProperty('${e.key}', ${e.key}))",
    ].join();

    return '''
    @override
    void debugFillProperties(DiagnosticPropertiesBuilder properties) {
      super.debugFillProperties(properties);
      properties
        ..add(DiagnosticsProperty('type', '${config.className}'))
        $diagnostics;
    }
    ''';
  }

  String _equalOperator() {
    String equality(TailorField field) {
      final name = field.name;
      return 'const DeepCollectionEquality().equals($name, other.$name)';
    }

    final comparisons = [
      'other.runtimeType == runtimeType',
      'other is ${config.className}',
      for (final field in config.fields.values) equality(field)
    ];

    return '''@override bool operator ==(Object other) {
      return identical(this, other) || (${comparisons.join('&&')});
    }
    ''';
  }

  String _hashCodeMethod() {
    String hashMethod(String val) => '@override int get hashCode{return $val;}';
    String hash(TailorField field) =>
        'const DeepCollectionEquality().hash(${field.name})';

    final hashedProps = [
      'runtimeType',
      for (final field in config.fields.values) hash(field)
    ];

    if (hashedProps.length == 1) {
      return hashMethod('${hashedProps.first}.hashCode');
    }

    if (hashedProps.length <= 20) {
      return hashMethod('Object.hash(${hashedProps.join(',')})');
    }

    return hashMethod('Object.hashAll([${hashedProps.join(',')}])');
  }

  String _themeModifier() => config.constantThemes ? 'const' : 'final';

  @override
  String toString() {
    return '''
    ${config.annotationManager.expandClassAnnotations()}
    class ${config.className} ${_classTypesDeclaration()} {
      ${_constructorAndParams()}
      ${_fromJsonFactory()}
      ${_generateThemes()}
      ${CopyWithTemplate(config.className, config.fields.values.toList())}
      ${_lerpMethod()}
      ${_debugFillPropertiesMethod()}
      ${_equalOperator()}
      ${_hashCodeMethod()}
    }
    ''';
  }
}
