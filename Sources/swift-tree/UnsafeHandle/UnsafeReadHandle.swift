import Foundation

protocol UnsafeReadHandleProtocol {
    associatedtype Element
    var __header_ptr: UnsafePointer<BaseTreeHeader> { get }
    var __node_ptr: UnsafePointer<_Node>{ get }
    var __value_ptr: UnsafePointer<Element>{ get }
}

extension UnsafeReadHandleProtocol {
    
    @inlinable
    @inline(__always)
    var __left_: _NodePtr {
        get { __header_ptr.pointee.__left_ }
    }
    
    @inlinable
    @inline(__always)
    var __begin_node: _NodePtr {
        get { __header_ptr.pointee.__begin_node }
    }
    
    @inlinable
    @inline(__always)
    var size: Int {
        get { __header_ptr.pointee.size }
    }
}

extension UnsafeReadHandleProtocol {
    
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
}
