import Foundation

extension RedBlackTree.Container {
  @inlinable @inline(__always)
  public init<S>(_ _a: S) where S: Collection, S.Element == Element {
    var _values: [Element] = _a + []
    var _header: RedBlackTree.Header = .zero
    self.nodes = [RedBlackTree.Node](
      unsafeUninitializedCapacity: _values.count
    ) { _nodes, initializedCount in
      withUnsafeMutablePointer(to: &_header) { _header in
        _values.withUnsafeMutableBufferPointer { _values in
          var count = 0
          func ___construct_node(_ __k: Element) -> _NodePtr {
            _nodes[count] = .zero
            _values[count] = __k
            defer { count += 1 }
            return count
          }
          let tree = _UnsafeUpdateHandle<Element>(
            __header_ptr: _header,
            __node_ptr: _nodes.baseAddress!,
            __value_ptr: _values.baseAddress!)
          var i = 0
          while i < _a.count {
            let __k = _values[i]
            i += 1
            var __parent = _NodePtr.nullptr
            let __child = tree.__find_equal(&__parent, __k)
            if tree.__ref_(__child) == .nullptr {
              let __h = ___construct_node(__k)
              tree.__insert_node_at(__parent, __child, __h)
            }
          }
          initializedCount = count
        }
      }
    }
    self.header = _header
    self.values = _values
  }

  @inlinable
  public var count: Int { header.size }

  @inlinable
  public var isEmpty: Bool { count == 0 }
}

extension RedBlackTree.Container {
  @inlinable
  @discardableResult
  public mutating func insert(_ p: Element) -> Bool {
    __insert_unique(p).__inserted
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

extension RedBlackTree.Container {

  public typealias Pointer = _NodePtr

  @inlinable
  public func begin() -> _NodePtr {
    __begin_node
  }

  @inlinable
  public func end() -> _NodePtr {
    .end
  }

  @inlinable
  public mutating func remove(at ptr: _NodePtr) -> Element? {
    ptr == .end ? nil : erase__(ptr)
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
    var ptr = ptr
    var n = distance
    while n != 0 {
      if n > 0 {
        if ptr == .nullptr {
          ptr = __begin_node
        } else if ptr != .end {
          ptr = _read { $0.__tree_next_iter(ptr) }
        }
        n -= 1
      }
      if n < 0 {
        if ptr == __begin_node {
          ptr = .nullptr
        } else {
          ptr = _read { $0.__tree_prev_iter(ptr) }
        }
        n += 1
      }
    }
    return ptr
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
      let p = _read {
        var count = 0
        var p = $0.__begin_node
        while p != .end {
          if p == ptr { break }
          p = $0.__tree_next_iter(p)
          count += 1
        }
        return count
      }
      return p
    }
  #endif
}

extension RedBlackTree.Container {
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

extension RedBlackTree.Container: Sequence {

  public struct Iterator: IteratorProtocol {
    @inlinable
    init(container: RedBlackTree.Container<Element>, ptr: _NodePtr) {
      self.container = container
      self.ptr = ptr
    }
    @usableFromInline
    let container: RedBlackTree.Container<Element>
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
