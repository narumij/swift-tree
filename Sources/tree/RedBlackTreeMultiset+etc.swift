import Foundation

extension RedBlackTreeMultiset {
  @inlinable @inline(__always)
  public init<S>(_ _a: S) where S: Collection, S.Element == Element {
    self.nodes = []
    self.header = .zero
    self.values = []
    for a in _a {
      insert(a)
    }
  }

  @inlinable
  public var count: Int { header.size }

  @inlinable
  public var isEmpty: Bool { count == 0 }
}

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
  @inlinable
  public func contains(_ p: Element) -> Bool {
    _read {
      let it = $0.__lower_bound(p, $0.__root(), $0.__left_)
      guard it >= 0 else { return false }
      return $0.__value_ptr[it] == p
    }
  }
  @inlinable
  public func lt(_ p: Element) -> Element? {
    _read {
      var it = $0.__lower_bound(p, $0.__root(), .end)
      if it == $0.__begin_node { return nil }
      it = $0.__tree_prev_iter(it)
      return it != .end ? $0.__value_ptr[it] : nil
    }
  }
  @inlinable
  public func gt(_ p: Element) -> Element? {
    _read {
      let it = $0.__upper_bound(p, $0.__root(), .end)
      return it != .end ? $0.__value_ptr[it] : nil
    }
  }
  @inlinable
  public func le(_ p: Element) -> Element? {
    _read {
      var __parent = _NodePtr.nullptr
      _ = $0.__find_equal(&__parent, p)
      if __parent == .nullptr {
        return nil
      }
      if __parent == $0.__begin_node,
        $0.value_comp(p, $0.__value_(__parent))
      {
        return nil
      }
      if $0.value_comp(p, $0.__value_(__parent)) {
        __parent = $0.__tree_prev_iter(__parent)
      }
      return __parent != .end ? $0.__value_(__parent) : nil
    }
  }
  @inlinable
  public func ge(_ p: Element) -> Element? {
    _read {
      var __parent = _NodePtr.nullptr
      _ = $0.__find_equal(&__parent, p)
      if __parent != .nullptr, __parent != .end, $0.value_comp($0.__value_(__parent), p) {
        __parent = $0.__tree_next_iter(__parent)
      }
      return __parent != .end ? $0.__value_(__parent) : nil
    }
  }
}

extension RedBlackTreeMultiset {

  public typealias Pointer = _NodePtr

  @inlinable
  public func begin() -> _NodePtr {
    header.__begin_node
  }

  @inlinable
  public func end() -> _NodePtr {
    .end
  }

  @inlinable
  public mutating func remove(at ptr: _NodePtr) -> Element? {
    guard ptr != .end else { return nil }
    let e = values[ptr]
    _ = erase(ptr)
    return e
  }

  @inlinable
  public func lower_bound(_ p: Element) -> _NodePtr {
    _read { $0.__lower_bound(p, $0.__root(), .end) }
  }

  @inlinable
  public func upper_bound(_ p: Element) -> _NodePtr {
    _read { $0.__upper_bound(p, $0.__root(), .end) }
  }

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

extension RedBlackTreeMultiset {
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
