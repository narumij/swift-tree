import Foundation

@usableFromInline
typealias _NodePtr = Int

extension _NodePtr {
    @usableFromInline
    static var nullptr: Self { -2 }
    @usableFromInline
    static var end: Self { -1 }
    @usableFromInline
    static func node(_ p: Int) -> Self { p }
}

enum _NodeRef: Equatable {
    case nullptr
    case __right_(_NodePtr)
    case __left_(_NodePtr)
}

protocol MemberProtocol {
    @inlinable
    func __parent_(_: _NodePtr) -> _NodePtr
    @inlinable
    func __left_(_: _NodePtr) -> _NodePtr
    @inlinable
    func __right_(_: _NodePtr) -> _NodePtr
    @inlinable
    func __is_black_(_: _NodePtr) -> Bool
    @inlinable
    func __parent_unsafe(_: _NodePtr) -> _NodePtr
}

protocol MemberSetProtocol: MemberProtocol {
    @inlinable
    func __is_black_(_ lhs: _NodePtr,_ rhs: Bool)
    @inlinable
    func __parent_(_ lhs: _NodePtr,_ rhs: _NodePtr)
    @inlinable
    func __left_(_ lhs: _NodePtr,_ rhs: _NodePtr)
    @inlinable
    func __right_(_ lhs: _NodePtr,_ rhs: _NodePtr)
}

protocol RefProtocol: MemberProtocol {
    @inlinable
    func __left_ref(_: _NodePtr) -> _NodeRef
    @inlinable
    func __right_ref(_: _NodePtr) -> _NodeRef
    @inlinable
    func __ref_(_ rhs: _NodeRef) -> _NodePtr
    @inlinable
    func __ref_(_ lhs: _NodeRef,_ rhs: _NodePtr)
}

protocol ValueProtocol: MemberProtocol {
    
    associatedtype Element
    func __value_(_: _NodePtr) -> Element
    func value_comp(_:Element,_:Element) -> Bool
}

protocol BeginNodeProtocol {
    var __begin_node: _NodePtr { get nonmutating set }
}

protocol RootProtocol {
    @inlinable
    func __root() -> _NodePtr
}

protocol RootPtrProrototol {
    @inlinable
    func __root_ptr() -> _NodeRef
}

protocol EndNodeProtocol {
    @inlinable
    func __end_node() -> _NodePtr
}

protocol EndProtocol {
    @inlinable
    func end() -> _NodePtr
}

protocol SizeProtocol {
    var size: Int { get nonmutating set }
}

