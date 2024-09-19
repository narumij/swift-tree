import Foundation

@frozen
@usableFromInline
struct _UnsafeReadHandle<Element: Comparable> {
    
    @inlinable
    @inline(__always)
    init(__header_ptr: UnsafePointer<RedBlackTree.Header>,
         __node_ptr: UnsafePointer<RedBlackTree.Node>,
         __value_ptr: UnsafePointer<Element>) {
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

extension _UnsafeReadHandle: ReadHandleImpl { }
