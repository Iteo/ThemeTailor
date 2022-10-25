import 'package:analyzer/dart/ast/ast.dart';

extension FieldDeclarationExtension on FieldDeclaration {
  String get name => fields.variables.first.name.toString();

  List<String> get annotations {
    return metadata.map((e) => e.toString()).toList(growable: false);
  }
}
