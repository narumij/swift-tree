import Foundation

extension RedBlackTreeMultiset {
  @inlinable @inline(__always)
  public init<S>(_ _a: S) where S: Collection, S.Element == Element {
    self.nodes = []
    self.header = .zero
    self.values = []
    for a in _a {
      _ = insert(a)
    }
  }
}

extension RedBlackTreeMultiset: RedBlackTreeSetUtil {}

extension RedBlackTreeMultiset {
  @inlinable
  public mutating func insert(_ p: Element) -> Bool {
    _ = __insert_multi(p)
    return true
  }
  
  @inlinable
  @discardableResult
  public mutating func remove(_ p: Element) -> Bool {
    return __erase_multi(p) != 0
  }

  @inlinable
  @discardableResult
  public mutating func remove(at ptr: _NodePtr) -> Element? {
    guard ptr != .end else { return nil }
    let e = values[ptr]
    _ = erase(ptr)
    return e
  }
}

// Sequenceプロトコルとの衝突があるため、直接の実装が必要
extension RedBlackTreeMultiset {

  @inlinable public func contains(_ p: Element) -> Bool { _contains(p) }
  @inlinable public func min() -> Element? { _min() }
  @inlinable public func max() -> Element? { _max() }
}

extension RedBlackTreeMultiset: Sequence {

  public typealias Iterator = RedBlackTree.Iterator<Self>

  @inlinable
  public func makeIterator() -> Iterator {
    .init(container: self, ptr: header.__begin_node)
  }
}

extension RedBlackTreeMultiset: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
