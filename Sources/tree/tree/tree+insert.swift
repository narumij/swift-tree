import Foundation

@usableFromInline
protocol NodeInsertProtocol: MemberSetProtocol
    & RefSetProtocol
    & SizeProtocol
    & BeginNodeProtocol
    & EndNodeProtocol
{}

extension NodeInsertProtocol {

  @inlinable
  func
    static_cast__iter_pointer(_ p: _NodePtr) -> _NodePtr
  { p }

  @inlinable
  func __tree_balance_after_insert(_ lhs: _NodePtr, _ rhs: _NodeRef) {
    __tree_balance_after_insert(lhs, __ref_(rhs))
  }
}

extension NodeInsertProtocol {

  @inlinable
  func
    __insert_node_at(
      _ __parent: _NodePtr, _ __child: _NodeRef,
      _ __new_node: _NodePtr
    )
  {
    __left_(__new_node, .nullptr)
    __right_(__new_node, .nullptr)
    __parent_(__new_node, __parent)
    // __new_node->__is_black_ is initialized in __tree_balance_after_insert
    __ref_(__child, __new_node)
    if __left_(__begin_node) != .nullptr {
      __begin_node = static_cast__iter_pointer(__left_(__begin_node))
    }
    __tree_balance_after_insert(__left_(__end_node()), __child)
    size += 1
  }
}

@usableFromInline
protocol StorageProtocol {

  associatedtype Element

  @inlinable
  mutating func __construct_node(_ k: Element) -> _NodePtr

  @inlinable
  mutating func destroy(_ p: _NodePtr)
}

@usableFromInline
protocol InsertUniqueProtocol: StorageProtocol {
  func __ref_(_ rhs: _NodeRef) -> _NodePtr
  mutating func
    __find_equal(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef
  mutating func
    __insert_node_at(
      _ __parent: _NodePtr, _ __child: _NodeRef,
      _ __new_node: _NodePtr)
}

extension InsertUniqueProtocol {

  @inlinable
  public mutating func __insert_unique(_ x: Element) -> (__r: _NodeRef, __inserted: Bool) {

    __emplace_unique_key_args(x)
  }

  @inlinable
  mutating func
    __emplace_unique_key_args(_ __k: Element) -> (__r: _NodeRef, __inserted: Bool)
  {
    var __parent = _NodePtr.nullptr
    let __child = __find_equal(&__parent, __k)
    let __r = __child
    var __inserted = false
    if __ref_(__child) == .nullptr {
      let __h = __construct_node(__k)
      __insert_node_at(__parent, __child, __h)
      __inserted = true
    }
    return (__r, __inserted)
  }
}
