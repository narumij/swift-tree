import Foundation

extension RedBlackTree {
    @frozen
    public struct Container<Element: Comparable> {
        
        public init() { }
        
        @usableFromInline
        var header: Header = .init()
        @usableFromInline
        var nodes: [Node] = []
        @usableFromInline
        var values: [Element] = []
        
        @usableFromInline
        var stock: [_NodePtr] = []
        
        @inlinable
        public mutating func reserveCapacity(_ minimumCapacity: Int) {
            nodes.reserveCapacity(minimumCapacity)
            values.reserveCapacity(minimumCapacity)
        }
    }
}

extension RedBlackTree.Container {
    
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

extension RedBlackTree.Container {
    
    @inlinable
    var __begin_node: _NodePtr {
        header.__begin_node
    }
    
    @inlinable
    mutating func __construct_node(_ k: Element) -> _NodePtr {
        if let stock = stock.popLast() {
            return stock
        }
        let n = values.count
        nodes.append(.init(__is_black_: false, __left_: .nullptr, __right_: .nullptr, __parent_: .nullptr))
        values.append(k)
        return n
    }
    
    @inlinable
    mutating func destroy(_ p: _NodePtr) {
        nodes[p].clear()
        stock.append(p)
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

extension RedBlackTree.Container: InsertUniqueProtocol { }

extension RedBlackTree.Container: EraseProtocol { }

extension RedBlackTree.Container {
    
    @inlinable mutating func
    erase__(_ __p: _NodePtr) -> Element?
    {
        let __value_ = _update { __p == .end ? nil : $0.__value_ptr[__p] }
        let __np     = __get_np(__p)
        _            = __remove_node_pointer(__np)
        destroy(__p)
        return __value_
    }
}


