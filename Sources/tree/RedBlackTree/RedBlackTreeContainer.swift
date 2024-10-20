import Foundation

@usableFromInline
protocol RedBlackTreeContainerBase: EndProtocol, ValueComparer {
  associatedtype Element
  var header: RedBlackTree.Header { get set }
  var nodes: [RedBlackTree.Node] { get set }
  var values: [Element] { get set }
}

extension RedBlackTreeContainerBase {

  @inlinable
  @inline(__always)
  func _read<R>(_ body: (_UnsafeHandle<Self>) throws -> R) rethrows -> R {
    return try withUnsafePointer(to: header) { header in
      try nodes.withUnsafeBufferPointer { nodes in
        try values.withUnsafeBufferPointer { values in
          try body(
            _UnsafeHandle<Self>(
              __header_ptr: header,
              __node_ptr: nodes.baseAddress!,
              __value_ptr: values.baseAddress!))
        }
      }
    }
  }
}

extension RedBlackTreeContainerBase {

  @inlinable
  public var count: Int { header.size }

  @inlinable
  public var isEmpty: Bool { count == 0 }

  @inlinable
  public func begin() -> _NodePtr {
    header.__begin_node
  }

  @inlinable
  public func end() -> _NodePtr {
    .end
  }
}

@usableFromInline
protocol RedBlackTreeContainer: RedBlackTreeContainerBase {}

extension RedBlackTreeContainer {

  @inlinable
  public subscript(node: _NodePtr) -> Element {
    values[node]
  }

  @inlinable public subscript(node: _NodePtr, offsetBy distance: Int) -> Element {
    element(node, offsetBy: distance)!
  }

  @inlinable func element(_ ptr: _NodePtr, offsetBy distance: Int) -> Element? {
    let ptr = pointer(ptr, offsetBy: distance)
    return ptr == .end ? nil : values[ptr]
  }

  @inlinable func pointer(_ ptr: _NodePtr, offsetBy distance: Int) -> _NodePtr {
    _read { $0.pointer(ptr, offsetBy: distance) }
  }

  #if DEBUG
    @inlinable
    var elements: [Element] {
      var result: [Element] = []
      var p = header.__begin_node
      _read {
        while p != .end {
          result.append($0.__value_(p))
          p = $0.__tree_next_iter(p)
        }
      }
      return result
    }

    func distance(to ptr: _NodePtr) -> Int {
      _read { $0.distance(to: ptr) }
    }
  #endif
}

@usableFromInline
protocol RedBlackTreeSetContainer: RedBlackTreeContainer {}

extension RedBlackTreeSetContainer {

  @inlinable
  mutating func __construct_node(_ k: Element) -> _NodePtr {
    #if false
      if let stock = stock.popLast() {
        return stock
      }
    #endif
    let n = Swift.min(nodes.count, values.count)
    nodes.append(.zero)
    values.append(k)
    return n
  }

  @inlinable
  mutating func destroy(_ p: _NodePtr) {
    #if false
      stock.append(p)
    #endif
  }
}

public
  protocol RedBlackTreeIteratee
{
  associatedtype Element
  func iteratorNext(ptr: _NodePtr) -> _NodePtr
  func iteratorValue(ptr: _NodePtr) -> Element
}

extension RedBlackTreeSetContainer {

  public func iteratorNext(ptr: _NodePtr) -> _NodePtr {
    _read { $0.__tree_next_iter(ptr) }
  }

  public func iteratorValue(ptr: _NodePtr) -> Element {
    values[ptr]
  }
}

extension RedBlackTreeSet: RedBlackTreeIteratee {}

extension RedBlackTreeMultiset: RedBlackTreeIteratee {}
