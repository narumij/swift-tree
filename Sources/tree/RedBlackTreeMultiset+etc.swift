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

  @inlinable
  public var count: Int { header.size }

  @inlinable
  public var isEmpty: Bool { count == 0 }
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
    __erase_unique(p)
  }
}

// Sequenceプロトコルとの衝突があるため、直接の実装が必要
extension RedBlackTreeMultiset {

  @inlinable
  public func contains(_ p: Element) -> Bool {
    _read {
      let it = $0.__lower_bound(p, $0.__root(), $0.__left_)
      guard it >= 0 else { return false }
      return $0.__value_ptr[it] == p
    }
  }

  @inlinable
  func min() -> Element? {
    _read {
      let p = $0.__tree_min($0.__root())
      return p == .end ? nil : $0.__value_(p)
    }
  }
  @inlinable
  func max() -> Element? {
    _read {
      let p = $0.__tree_max($0.__root())
      return p == .end ? nil : $0.__value_(p)
    }
  }
}

extension RedBlackTreeMultiset {

  public typealias Pointer = _NodePtr

  @inlinable
  public mutating func remove(at ptr: _NodePtr) -> Element? {
    guard ptr != .end else { return nil }
    let e = values[ptr]
    _ = erase(ptr)
    return e
  }

  @inlinable func pointer(_ ptr: _NodePtr, offsetBy distance: Int) -> _NodePtr {
    _read { $0.pointer(ptr, offsetBy: distance) }
  }
}

extension RedBlackTreeMultiset: Sequence {

  public struct Iterator: IteratorProtocol {
    @inlinable
    init(container: RedBlackTreeMultiset<Element>, ptr: _NodePtr) {
      self.container = container
      self.ptr = ptr
    }
    @usableFromInline
    let container: RedBlackTreeMultiset<Element>
    @usableFromInline
    var ptr: _NodePtr
    @inlinable
    public mutating func next() -> Element? {
      defer {
        if ptr != .end {
          ptr = container._read { $0.__tree_next_iter(ptr) }
        }
      }
      return ptr == .end ? nil : container.values[ptr]
    }
  }
    
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
