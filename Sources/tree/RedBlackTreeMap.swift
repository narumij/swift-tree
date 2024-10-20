import Foundation

public
  protocol RedBlackTreeMapKeyProtocol
{
  associatedtype Key
  static func value_comp(_ a: Key, _ b: Key) -> Bool
}

@frozen
public
  enum KeyInfo<Key: Comparable>: RedBlackTreeMapKeyProtocol
{
  public typealias Key = Key
  @inlinable
  public static func
    value_comp(_ a: Key, _ b: Key) -> Bool
  {
    a < b
  }
}

public
  typealias RedBlackTreeMap<Key: Comparable, Value> = RedBlackTreeMapBase<KeyInfo<Key>, Value>

@frozen
public struct RedBlackTreeMapBase<KeyInfo, Value>
where KeyInfo: RedBlackTreeMapKeyProtocol  //, KeyInfo.Key: Equatable
{

  public
    typealias Key = KeyInfo.Key

  public
    typealias Value = Value

  @usableFromInline
  typealias _Key = Key

  public init() {
    header = .zero
    nodes = []
    values = []
  }

  public subscript(key: Key) -> Value? {
    get {
      _read {
        let it = $0.__lower_bound(key, $0.__root(), $0.__left_)
        guard it >= 0,
          !Self.value_comp(Self.__key($0.__value_ptr[it]), key),
          !Self.value_comp(key, Self.__key($0.__value_ptr[it]))
        else { return nil }
        return Self.__value($0.__value_ptr[it])
      }
    }
    set {
      if let newValue {
        _ = __insert_unique((key, newValue))
      } else {
        _ = __erase_unique(key)
      }
    }
  }

  @usableFromInline
  var header: RedBlackTree.Header
  @usableFromInline
  var nodes: [RedBlackTree.Node]
  @usableFromInline
  var values: [Element]

  public var count: Int { header.size }
  public var isEmpty: Bool { count == 0 }
}

extension RedBlackTreeMapBase: ValueComparer {

  @inlinable
  static func __key(_ kv: (Key, Value)) -> Key { kv.0 }

  @inlinable
  static func __value(_ kv: (Key, Value)) -> Value { kv.1 }

  @inlinable
  static func value_comp(_ a: Key, _ b: Key) -> Bool {
    KeyInfo.value_comp(a, b)
  }
}

extension RedBlackTreeMapBase: RedBlackTreeContainer, _UnsafeHandleBase { }

extension RedBlackTreeMapBase: _UnsafeMutatingHandleBase {

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

extension RedBlackTreeMapBase: InsertUniqueProtocol, EraseProtocol {

  @inlinable
  mutating func __construct_node(_ k: (Key, Value)) -> _NodePtr {
    let n = Swift.min(nodes.count, values.count)
    nodes.append(.zero)
    values.append(k)
    return n
  }

  @inlinable
  mutating func destroy(_ p: _NodePtr) {
    //    fatalError()
  }
}
