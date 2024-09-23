import Foundation

@usableFromInline
protocol ValueComparer {
  associatedtype _Key
  associatedtype Element
  static func __key(_: Element) -> _Key
  static func value_comp(_: _Key, _: _Key) -> Bool
}

@usableFromInline
protocol _UnsafeHandleCommon {
  associatedtype VC: ValueComparer
}

extension _UnsafeHandleCommon {

  @usableFromInline
  typealias _Key = VC._Key

  @usableFromInline
  typealias Element = VC.Element

  @inlinable func __value_(_ e: VC.Element) -> _Key {
    VC.__key(e)
  }

  @inlinable func value_comp(_ a: _Key, _ b: _Key) -> Bool {
    VC.value_comp(a, b)
  }
}

@frozen
@usableFromInline
struct _UnsafeHandle<VC> where VC: ValueComparer {

  @inlinable
  @inline(__always)
  init(
    __header_ptr: UnsafePointer<RedBlackTree.Header>,
    __node_ptr: UnsafePointer<RedBlackTree.Node>,
    __value_ptr: UnsafePointer<Element>
  ) {
    self.__header_ptr = __header_ptr
    self.__node_ptr = __node_ptr
    self.__value_ptr = __value_ptr
  }
  @usableFromInline
  let __header_ptr: UnsafePointer<RedBlackTree.Header>
  @usableFromInline
  let __node_ptr: UnsafePointer<RedBlackTree.Node>
  @usableFromInline
  let __value_ptr: UnsafePointer<Element>
}

extension _UnsafeHandle: _UnsafeHandleCommon {

  @inlinable func __value_(_ p: _NodePtr) -> _Key {
    __value_(__value_ptr[p])
  }
}

extension _UnsafeHandle: ReadHandleImpl {}
extension _UnsafeHandle: NodeFindProtocol & NodeFindEtcProtocol & FindLeafEtcProtocol {}

@usableFromInline
protocol _UnsafeHandleBase {
  associatedtype VC: ValueComparer
  func _read<R>(_ body: (_UnsafeHandle<VC>) throws -> R) rethrows -> R
}

extension _UnsafeHandleBase {

  @inlinable
  func __ref_(_ rhs: _NodeRef) -> _NodePtr {
    _read { $0.__ref_(rhs) }
  }

  @inlinable
  func __find_equal(_ __parent: inout _NodePtr, _ __v: VC._Key) -> _NodeRef {
    _read { $0.__find_equal(&__parent, __v) }
  }

  @inlinable
  func find(_ __v: VC._Key) -> _NodePtr {
    _read { $0.find(__v) }
  }
}

@frozen
@usableFromInline
struct _UnsafeMutatingHandle<VC> where VC: ValueComparer {

  @inlinable @inline(__always)
  init(
    __header_ptr: UnsafeMutablePointer<RedBlackTree.Header>,
    __node_ptr: UnsafeMutablePointer<RedBlackTree.Node>,
    __value_ptr: UnsafeMutablePointer<Element>
  ) {
    self.__header_ptr = __header_ptr
    self.__node_ptr = __node_ptr
    self.__value_ptr = __value_ptr
  }
  @usableFromInline
  let __header_ptr: UnsafeMutablePointer<RedBlackTree.Header>
  @usableFromInline
  let __node_ptr: UnsafeMutablePointer<RedBlackTree.Node>
  @usableFromInline
  let __value_ptr: UnsafeMutablePointer<Element>
}

extension _UnsafeMutatingHandle: _UnsafeHandleCommon {

  @inlinable func __value_(_ p: _NodePtr) -> _Key {
    __value_(__value_ptr[p])
  }
}

extension _UnsafeMutatingHandle: UpdateHandleImpl {}
extension _UnsafeMutatingHandle: NodeFindProtocol & NodeFindEtcProtocol {}
extension _UnsafeMutatingHandle: NodeInsertProtocol {}
extension _UnsafeMutatingHandle: RemoveProtocol {}

@usableFromInline
protocol _UnsafeMutatingHandleBase {
  associatedtype VC: ValueComparer
  mutating func _update<R>(_ body: (_UnsafeMutatingHandle<VC>) throws -> R) rethrows -> R
}

extension _UnsafeMutatingHandleBase {

  @inlinable
  mutating func __ref_(_ rhs: _NodeRef) -> _NodePtr {
    _update { $0.__ref_(rhs) }
  }

  @inlinable
  mutating func __find_equal(_ __parent: inout _NodePtr, _ __v: VC._Key) -> _NodeRef {
    _update { $0.__find_equal(&__parent, __v) }
  }

  @inlinable
  mutating func __insert_node_at(_ __parent: _NodePtr, _ __child: _NodeRef, _ __new_node: _NodePtr)
  {
    _update { $0.__insert_node_at(__parent, __child, __new_node) }
  }

  @inlinable
  mutating func find(_ __v: VC._Key) -> _NodePtr {
    _update { $0.find(__v) }
  }

  @inlinable
  mutating func __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr {
    _update { $0.__remove_node_pointer(__ptr) }
  }
}
