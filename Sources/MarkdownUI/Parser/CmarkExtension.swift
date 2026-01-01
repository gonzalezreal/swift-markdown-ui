/// Describes extension to parse custom inline nodes in cmark.
public struct CmarkExtension: Sendable {
  /// Extension name to pass to cmark
  public var name: String

  /// Registers extension in cmark
  public var register: @Sendable () -> Void

  /// Name to identify cmark node
  public var nodeName: String

  /// This is pointer to `cmark_node`
  public var makeNode: @Sendable (UnsafeMutableRawPointer) -> CustomInline?

  public init(
    name: String,
    register: @escaping @Sendable () -> Void,
    nodeName: String,
    makeNode: @escaping @Sendable (UnsafeMutableRawPointer) -> CustomInline?,
  ) {
    self.name = name
    self.register = register
    self.nodeName = nodeName
    self.makeNode = makeNode
  }
}
