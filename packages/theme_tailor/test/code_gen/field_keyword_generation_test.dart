import 'package:build/build.dart';
import 'package:source_gen_test/source_gen_test.dart';
import 'package:theme_tailor/src/generator/theme_tailor_generator.dart';

Future<void> main() async {
  initializeBuildLogTracking();
  const annotatedTests = {
    '\$_ThrowErrorOnFinalIncluded',
    '\$_GenerateConstantTheme',
    '\$_GenerateConstantOverGetters',
    '\$_GenerateGetters',
    '\$_GenerateFinalsOnUnsupportedKeywordIncluded'
  };

  final reader = await initializeLibraryReaderForDirectory(
    'test/code_gen/inputs',
    'field_keyword_generation_test_input.dart',
  );

  testAnnotatedElements(
    reader,
    ThemeTailorGenerator(
      builderOptions: BuilderOptions({}),
    ),
    expectedAnnotatedTests: annotatedTests,
  );
}
