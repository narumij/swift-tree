import Foundation

@frozen
@usableFromInline
struct _UnsafeUpdateHandle<Element: Comparable> {
    
    @inlinable
    @inline(__always)
    init(__header_ptr: UnsafeMutablePointer<RedBlackTreeHeader>,
         __node_ptr: UnsafeMutablePointer<RedBlackTreeNode>,
         __value_ptr: UnsafeMutablePointer<Element>) {
        self.__header_ptr = __header_ptr
        self.__node_ptr = __node_ptr
        self.__value_ptr = __value_ptr
    }
    @usableFromInline
    let __header_ptr: UnsafeMutablePointer<RedBlackTreeHeader>
    @usableFromInline
    let __node_ptr: UnsafeMutablePointer<RedBlackTreeNode>
    @usableFromInline
    let __value_ptr: UnsafeMutablePointer<Element>
}

extension _UnsafeUpdateHandle: UpdateHandleImpl { }
extension _UnsafeUpdateHandle: NodeFindProtocol & NodeFindEtcProtocol { }
extension _UnsafeUpdateHandle: NodeInsertProtocol { }
extension _UnsafeUpdateHandle: RemoveProtocol { }
