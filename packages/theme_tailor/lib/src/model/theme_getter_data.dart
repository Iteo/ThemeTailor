import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

typedef Callback<T> = T Function();

extension ThemeGetterExtension on ThemeGetter {
  ExtensionData get extensionData => ExtensionData.values.byName(name);
}

enum ExtensionTarget {
  none('none'),
  buildContext('BuildContext'),
  themeData('ThemeData');

  const ExtensionTarget(this.name);

  final String name;

  String _extensionOfType(String type) => 'extension<$type>()!';

  String themeExtensionAccessor(String type) {
    switch (this) {
      case ExtensionTarget.buildContext:
        return 'Theme.of(this).${_extensionOfType(type)}';
      case ExtensionTarget.themeData:
        return _extensionOfType(type);
      default:
        throw UnimplementedError();
    }
  }
}

enum ExtensionData {
  none(
    shortName: 'none',
    target: ExtensionTarget.none,
    shouldGenerate: false,
    hasGeneratedProps: false,
    hasPublicThemeGetter: false,
  ),
  onThemeData(
    shortName: 'ThemeData',
    target: ExtensionTarget.themeData,
    shouldGenerate: true,
    hasGeneratedProps: false,
    hasPublicThemeGetter: true,
  ),
  onThemeDataProps(
    shortName: 'ThemeDataProps',
    target: ExtensionTarget.themeData,
    shouldGenerate: true,
    hasGeneratedProps: true,
    hasPublicThemeGetter: false,
  ),
  onBuildContext(
    shortName: 'BuildContext',
    target: ExtensionTarget.buildContext,
    shouldGenerate: true,
    hasGeneratedProps: false,
    hasPublicThemeGetter: true,
  ),
  onBuildContextProps(
    shortName: 'BuildContextProps',
    target: ExtensionTarget.buildContext,
    shouldGenerate: true,
    hasGeneratedProps: true,
    hasPublicThemeGetter: false,
  );

  const ExtensionData({
    required this.shortName,
    required this.target,
    required this.shouldGenerate,
    required this.hasGeneratedProps,
    required this.hasPublicThemeGetter,
  });

  final String shortName;
  final ExtensionTarget target;
  final bool shouldGenerate;
  final bool hasGeneratedProps;
  final bool hasPublicThemeGetter;
}
