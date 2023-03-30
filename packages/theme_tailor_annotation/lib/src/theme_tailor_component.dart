import 'package:meta/meta_meta.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

/// Default instance of [TailorComponent] annotation
const tailorComponent = TailorComponent();

/// An annotation used to specify that generated ThemeExtension class can be
/// used as a part of other ThemeExtension class and does not need additional
/// extensions on BuildContext nor ThemeData for the ease of access
@Target({TargetKind.classType})
class TailorComponent extends Tailor {
  const TailorComponent({
    super.themes,
    super.encoders,
    super.requireStaticConst,
    super.generateStaticGetters,
  }) : super(themeGetter: ThemeGetter.none);
}
