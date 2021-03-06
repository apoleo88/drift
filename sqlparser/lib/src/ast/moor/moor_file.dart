import '../node.dart';
import '../statements/statement.dart';
import '../visitor.dart';
import 'declared_statement.dart';
import 'import_statement.dart';

/// Marker interface for AST nodes that are moor-specific.
abstract class MoorSpecificNode implements AstNode {}

/// Something that can appear as a top-level declaration inside a `.moor` file.
abstract class PartOfMoorFile implements Statement, MoorSpecificNode {}

/// A moor file.
///
/// A moor file consists of [ImportStatement], followed by ddl statements,
/// followed by [DeclaredStatement]s.
class MoorFile extends AstNode implements MoorSpecificNode {
  List<PartOfMoorFile> statements;

  MoorFile(this.statements);

  @override
  R accept<A, R>(AstVisitor<A, R> visitor, A arg) {
    return visitor.visitMoorSpecificNode(this, arg);
  }

  @override
  void transformChildren<A>(Transformer<A> transformer, A arg) {
    statements = transformer.transformChildren(statements, this, arg);
  }

  @override
  Iterable<AstNode> get childNodes => statements;

  /// Returns the imports defined in this file.
  Iterable<ImportStatement> get imports =>
      childNodes.whereType<ImportStatement>();
}

class MoorTableName extends AstNode implements MoorSpecificNode {
  final String overriddenDataClassName;
  final bool useExistingDartClass;

  MoorTableName(this.overriddenDataClassName, this.useExistingDartClass);

  @override
  R accept<A, R>(AstVisitor<A, R> visitor, A arg) {
    return visitor.visitMoorSpecificNode(this, arg);
  }

  @override
  Iterable<AstNode> get childNodes => const Iterable.empty();

  @override
  void transformChildren<A>(Transformer<A> transformer, A arg) {}
}
