import Foundation

@frozen
public struct RedBlackTreeContainer<Element: Comparable> {
    
    public init() { }
    
    @usableFromInline
    var header: RedBlackTreeHeader = .init()
    @usableFromInline
    var nodes: [RedBlackTreeNode] = []
    @usableFromInline
    var values: [Element] = []
    
    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        nodes.reserveCapacity(minimumCapacity)
        values.reserveCapacity(minimumCapacity)
    }
}

extension RedBlackTreeContainer {
    
    @inlinable
    @inline(__always)
    func _read<R>(_ body: (_UnsafeReadHandle<Element>) throws -> R) rethrows -> R {
        return try withUnsafePointer(to: header) { header in
            try nodes.withUnsafeBufferPointer { nodes in
                try values.withUnsafeBufferPointer { values in
                    try body(_UnsafeReadHandle<Element>(
                        __header_ptr: header,
                        __node_ptr: nodes.baseAddress!,
                        __value_ptr: values.baseAddress!))
                }
            }
        }
    }
    
    @inlinable
    @inline(__always)
    mutating func _update<R>(_ body: (_UnsafeUpdateHandle<Element>) throws -> R) rethrows -> R {
        return try withUnsafeMutablePointer(to: &header) { header in
            try nodes.withUnsafeMutableBufferPointer { nodes in
                try values.withUnsafeMutableBufferPointer { values in
                    try body(_UnsafeUpdateHandle<Element>(
                        __header_ptr: header,
                        __node_ptr: nodes.baseAddress!,
                        __value_ptr: values.baseAddress!))
                }
            }
        }
    }
}

extension RedBlackTreeContainer {
    @inlinable
    mutating func __construct_node(_ k: Element) -> _NodePtr {
        let n = values.count
        nodes.append(.init(__is_black_: false, __left_: .nullptr, __right_: .nullptr, __parent_: .nullptr))
        values.append(k)
        return n
    }
    
    @inlinable
    mutating func destroy(_ p: _NodePtr) {
        //        fatalError()
        nodes[p].clear()
    }
    
    @inlinable
    func __left_(_ p: _NodePtr) -> _NodePtr {
        p == .end ? header.__left_ : nodes[p].__left_
    }
    @inlinable
    func __right_(_ p: _NodePtr) -> _NodePtr {
        nodes[p].__right_
    }
    @inlinable
    func __ptr_(_ rhs: _NodeRef) -> _NodePtr {
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
    func end() -> _NodePtr { .end }
    
    @inlinable
    mutating func __find_equal(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef {
        _update{ $0.__find_equal(&__parent, __v) }
    }
    
    @inlinable
    mutating func __insert_node_at(_ __parent: _NodePtr, _ __child: _NodeRef, _ __new_node: _NodePtr) {
        _update{ $0.__insert_node_at(__parent, __child, __new_node) }
    }
    
    @inlinable
    mutating func __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr {
        _update{ $0.__remove_node_pointer(__ptr) }
    }
    
    @inlinable
    mutating func find(_ __v: Element) -> _NodePtr {
        _update { $0.find(__v) }
    }
}

extension RedBlackTreeContainer {
    
    @inlinable
    public
    mutating func
    __insert_unique(_ x: Element) -> (__r: _NodeRef, __inserted: Bool) {
        
        __emplace_unique_key_args(x)
    }
    
    @inlinable
    mutating func
    __emplace_unique_key_args(_ __k: Element) -> (_NodeRef, Bool)
    {
        var __parent: _NodePtr = .nullptr
        let __child    = __find_equal(&__parent, __k)
        let __r        = __child
        var __inserted = false
        if __ptr_(__child) == .nullptr {
            let __h = __construct_node(__k)
            __insert_node_at(__parent, __child, __h)
            __inserted = true
        }
        return (__r, __inserted)
    }

}

extension RedBlackTreeContainer {
    
    @inlinable func
    __get_np(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable mutating func
    erase(_ __p: _NodePtr) -> _NodePtr
    {
        let __np    = __get_np(__p)
        let __r     = __remove_node_pointer(__np)
        destroy(__p)
        return __r
    }
    
    @inlinable mutating func
    erase__(_ __p: _NodePtr) -> Element?
    {
        var __value_ = _update { __p == .end ? nil : $0.__value_ptr[__p] }
        let __np    = __get_np(__p)
        let __r     = __remove_node_pointer(__np)
        destroy(__p)
        return __value_
    }

    
    @inlinable mutating func
    __erase_unique(_ __k: Element) -> Int {
        let __i = find(__k)
        if (__i == end()) {
            return 0 }
        _ = erase(__i)
        return 1
    }
}


