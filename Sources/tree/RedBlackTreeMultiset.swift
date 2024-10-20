import Foundation

@frozen
public struct RedBlackTreeMultiset<Element: Comparable> {

  @usableFromInline
  typealias _Key = Element

  @inlinable @inline(__always)
  public init() {
    header = .zero
    nodes = []
    values = []
  }

  @inlinable
  public init(minimumCapacity: Int) {
    header = .zero
    nodes = []
    values = []
    nodes.reserveCapacity(minimumCapacity)
    values.reserveCapacity(minimumCapacity)
  }

  @usableFromInline
  var header: RedBlackTree.Header
  @usableFromInline
  var nodes: [RedBlackTree.Node]
  @usableFromInline
  var values: [Element]

  #if false
    @usableFromInline
    var stock: [_NodePtr] = []
  #endif

  @inlinable
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
    nodes.reserveCapacity(minimumCapacity)
    values.reserveCapacity(minimumCapacity)
  }
}

extension RedBlackTreeMultiset: ValueComparer {

  @inlinable @inline(__always)
  static func __key(_ e: Element) -> Element { e }

  @inlinable
  static func value_comp(_ a: Element, _ b: Element) -> Bool {
    a < b
  }
}

extension RedBlackTreeMultiset: RedBlackTreeSetContainer { }
extension RedBlackTreeMultiset: _UnsafeHandleBase { }

extension RedBlackTreeMultiset: _UnsafeMutatingHandleBase {

  @inlinable
  @inline(__always)
  mutating func _update<R>(_ body: (_UnsafeMutatingHandle<Self>) throws -> R) rethrows -> R {
    return try withUnsafeMutablePointer(to: &header) { header in
      try nodes.withUnsafeMutableBufferPointer { nodes in
        try values.withUnsafeMutableBufferPointer { values in
          try body(
            _UnsafeMutatingHandle<Self>(
              __header_ptr: header,
              __node_ptr: nodes.baseAddress!,
              __value_ptr: values.baseAddress!))
        }
      }
    }
  }
}

extension RedBlackTreeMultiset: InsertMultiProtocol {}
extension RedBlackTreeMultiset: EraseProtocol {}
