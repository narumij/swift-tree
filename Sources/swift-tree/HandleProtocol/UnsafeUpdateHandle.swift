import Foundation

@usableFromInline
protocol UnsafeUpdateHeaderProtocol {
    associatedtype Element
    var __header_ptr: UnsafeMutablePointer<RedBlackTreeHeader> { get }
    var __node_ptr: UnsafeMutablePointer<RedBlackTreeNode>{ get }
    var __value_ptr: UnsafeMutablePointer<Element>{ get }
}

extension UnsafeUpdateHeaderProtocol {
    
    @inlinable
    var __left_: _NodePtr {
        @inline(__always) get { __header_ptr.pointee.__left_ }
        nonmutating set { __header_ptr.pointee.__left_ = newValue }
    }
    
    @inlinable
    var __begin_node: _NodePtr {
        @inline(__always) get { __header_ptr.pointee.__begin_node }
        nonmutating set { __header_ptr.pointee.__begin_node = newValue }
    }
    
    @inlinable
    var size: Int {
        @inline(__always) get { __header_ptr.pointee.size }
        nonmutating set { __header_ptr.pointee.size = newValue }
    }
}

extension UnsafeUpdateHeaderProtocol {
    
    @inlinable
    @inline(__always)
    func __parent_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__parent_
    }
    @inlinable
    @inline(__always)
    func __left_(_ p: _NodePtr) -> _NodePtr {
        p == .end ? __left_ : __node_ptr[p].__left_
    }
    @inlinable
    @inline(__always)
    func __right_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__right_
    }
    @inlinable
    @inline(__always)
    func __is_black_(_ p: _NodePtr) -> Bool {
        __node_ptr[p].__is_black_
    }
    @inlinable
    @inline(__always)
    func __parent_unsafe(_ p: _NodePtr) -> _NodePtr {
        __parent_(p)
    }

    @inlinable
    @inline(__always)
    func __is_black_(_ lhs: _NodePtr,_ rhs: Bool) {
        __node_ptr[lhs].__is_black_ = rhs
    }
    @inlinable
    func __parent_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        __node_ptr[lhs].__parent_ = rhs
    }
    @inlinable
    func __left_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        if lhs == .end {
            __left_ = rhs
        }
        else {
            __node_ptr[lhs].__left_ = rhs
        }
    }
    @inlinable
    func __right_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        __node_ptr[lhs].__right_ = rhs
    }
}

extension UnsafeUpdateHeaderProtocol {
    
    @inlinable
    func __value_(_ p: _NodePtr) -> Element { __value_ptr[p] }

    @inlinable
    func __ref_(_ rhs: _NodeRef) -> _NodePtr {
        switch rhs {
        case .nullptr:
            return .nullptr
        case .__right_(let basePtr):
            return __right_(basePtr)
        case .__left_(let basePtr):
            return __left_(basePtr)
        }
    }
    
    @inlinable
    func __ref_(_ lhs: _NodeRef,_ rhs: _NodePtr) {
        switch lhs {
        case .nullptr:
            fatalError()
        case .__right_(let basePtr):
            return __right_(basePtr, rhs)
        case .__left_(let basePtr):
            return __left_(basePtr, rhs)
        }
    }

    @inlinable
    func __left_ref(_ p: _NodePtr) -> _NodeRef {
        .__left_(p)
    }
    @inlinable
    func __right_ref(_ p: _NodePtr) -> _NodeRef {
        .__right_(p)
    }

    @inlinable
    func __root() -> _NodePtr { __left_(__end_node()) }

    @inlinable
    func __root_ptr() -> _NodeRef { __left_ref(__end_node()) }

    @inlinable
    func __end_node() -> _NodePtr { .end }
    
    @inlinable
    func end() -> _NodePtr { .end }
}
