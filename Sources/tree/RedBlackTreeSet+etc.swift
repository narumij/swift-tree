import Foundation

extension RedBlackTreeSet {
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
          let tree = _UnsafeMutatingHandle<Self>(
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

extension RedBlackTreeSet: RedBlackTreeSetUtil {}

extension RedBlackTreeSet {
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
}

// Sequenceプロトコルとの衝突があるため、直接の実装が必要
extension RedBlackTreeSet {

  @inlinable
  public func contains(_ p: Element) -> Bool { _contains(p) }

  @inlinable
  public func min() -> Element? { _min() }
  
  @inlinable
  public func max() -> Element? { _max() }
}

extension RedBlackTreeSet {

  public typealias Pointer = _NodePtr

  @inlinable
  public mutating func remove(at ptr: _NodePtr) -> Element? {
    guard ptr != .end else { return nil }
    let e = values[ptr]
    _ = erase(ptr)
    return e
  }
}

extension RedBlackTreeSet: Sequence {

  public struct Iterator: IteratorProtocol {
    @inlinable
    init(container: RedBlackTreeSet<Element>, ptr: _NodePtr) {
      self.container = container
      self.ptr = ptr
    }
    @usableFromInline
    let container: RedBlackTreeSet<Element>
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

extension RedBlackTreeSet: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
}
