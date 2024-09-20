import Foundation

extension RedBlackTree.Container {
    @inlinable
    public mutating func insert(_ p: Element) -> Bool {
        __insert_unique(p).__inserted
    }
    @inlinable
    public mutating func remove(_ p: Element) -> Bool {
        __erase_unique(p) == 1
    }
    @inlinable
    public func contains(_ p: Element) -> Bool {
        _read {
            let it = $0.__lower_bound(p, $0.__root(), $0.__left_)
            guard it >= 0 else { return false }
            return $0.__value_ptr[it] == p
        }
    }
    @inlinable
    public func lt(_ p: Element) -> Element? {
        _read {
            var it = $0.__lower_bound(p, $0.__root(), .end)
            if it == $0.__begin_node { return nil }
            it = $0.__tree_prev_iter(it)
            return it != .end ? $0.__value_ptr[it] : nil
        }
    }
    @inlinable
    public func gt(_ p: Element) -> Element? {
        _read {
            let it = $0.__upper_bound(p, $0.__root(), .end)
            return it != .end ? $0.__value_ptr[it] : nil
        }
    }
    @inlinable
    public func le(_ p: Element) -> Element? {
        _read {
            var __parent = _NodePtr.nullptr
            _            = $0.__find_equal(&__parent, p)
            if __parent == .nullptr {
                return nil
            }
            if __parent == $0.__begin_node,
               $0.value_comp(p, $0.__value_(__parent)) {
                return nil
            }
            if $0.value_comp(p, $0.__value_(__parent)) {
                __parent = $0.__tree_prev_iter(__parent)
            }
            return __parent != .end ? $0.__value_(__parent) : nil
        }
    }
    @inlinable
    public func ge(_ p: Element) -> Element? {
        _read {
            var __parent = _NodePtr.nullptr
            _            = $0.__find_equal(&__parent, p)
            if __parent != .nullptr, __parent != .end, $0.value_comp($0.__value_(__parent),p) {
                __parent = $0.__tree_next_iter(__parent)
            }
            return __parent != .end ? $0.__value_(__parent) : nil
        }
    }
    
    @inlinable
    public var count: Int { header.size }
    
    @inlinable
    public var isEmpty: Bool { count == 0 }
    
    @inlinable
    public init<S>(_ _a: S) where S: Collection, S.Element == Element {
        self.init()
        reserveCapacity(_a.count)
        for a in _a {
            _ = __insert_unique(a)
        }
    }
}

extension RedBlackTree.Container {

    @usableFromInline
    typealias Pointer = _NodePtr

    @inlinable
    func begin() -> _NodePtr {
        __begin_node
    }
    
    @inlinable
    func end() -> _NodePtr {
        .end
    }
    
    @inlinable
    mutating func element(at ptr: _NodePtr) -> Element! {
        ptr == .end ? nil : values[ptr]
    }
    
    @inlinable
    mutating func remove(at ptr: _NodePtr) -> Element? {
        ptr == .end ? nil : erase__(ptr)
    }
    
    @inlinable
    func lower_bound(_ p: Element) -> _NodePtr {
        _read { $0.__lower_bound(p, $0.__root(), .end) }
    }
    
    @inlinable
    func upper_bound(_ p: Element) -> _NodePtr {
        _read { $0.__upper_bound(p, $0.__root(), .end) }
    }

    @inlinable
    var elements: [Element] {
        var result: [Element] = []
        var p = header.__begin_node
        _read {
            while p != .end {
                result.append($0.__value_(p))
                p = $0.__tree_next_iter(p)
            }
        }
        return result
    }

    @inlinable
    subscript(node: _NodePtr) -> Element {
        values[node]
    }

    @inlinable
    subscript(node: _NodePtr, offsetBy distance: Int) -> Element {
        element(node, offsetBy: distance)!
    }
    
    @inlinable public func element(_ ptr: _NodePtr, offsetBy distance: Int) -> Element? {
        var ptr = ptr
        var n = distance
        while n != 0 {
            if n > 0 {
                if ptr == .nullptr {
                    ptr = __begin_node
                } else if ptr != .end {
                    ptr = _read { $0.__tree_next_iter(ptr) }
                }
                n -= 1
            }
            if n < 0 {
                if ptr == __begin_node {
                    ptr = .nullptr
                } else {
                    ptr = _read { $0.__tree_prev_iter(ptr) }
                }
                n += 1
            }
        }
        return ptr == .end ? nil : values[ptr]
    }

    @inlinable public func pointer(_ ptr: _NodePtr, offsetBy distance: Int) -> _NodePtr {
        var ptr = ptr
        var n = distance
        while n != 0 {
            if n > 0 {
                if ptr == .nullptr {
                    ptr = __begin_node
                } else if ptr != .end {
                    ptr = _read { $0.__tree_next_iter(ptr) }
                }
                n -= 1
            }
            if n < 0 {
                if ptr == __begin_node {
                    ptr = .nullptr
                } else {
                    ptr = _read { $0.__tree_prev_iter(ptr) }
                }
                n += 1
            }
        }
        return ptr
    }

#if DEBUG
    func distance(to ptr: _NodePtr) -> Int {
        let p = _read{
            var count = 0
            var p = $0.__begin_node
            while p != .end {
                if p == ptr { break }
                p = $0.__tree_next_iter(p)
                count += 1
            }
            return count
        }
        return p
    }
#endif
}

extension RedBlackTree.Container {
    @inlinable
    func min() -> Element? {
        _read {
            let p = $0.__tree_min($0.__root())
            return p == .end ? nil : $0.__value_(p)
        }
    }
    @inlinable
    func max() -> Element? {
        _read {
            let p = $0.__tree_max($0.__root())
            return p == .end ? nil : $0.__value_(p)
        }
    }
}

extension RedBlackTree.Container: Sequence {
    
    public struct Iterator: IteratorProtocol {
        @inlinable
        init(container: RedBlackTree.Container<Element>, ptr: _NodePtr) {
            self.container = container
            self.ptr = ptr
        }
        @usableFromInline
        let container: RedBlackTree.Container<Element>
        @usableFromInline
        var ptr: _NodePtr
        @inlinable
        public mutating func next() -> Element? {
            defer {
                if ptr != .end {
                    ptr = container._read { $0.__tree_next_iter(ptr) }
                }
            }
            return ptr == .end ? nil : container.values[ptr]
        }
    }
    @inlinable
    public func makeIterator() -> Iterator {
        .init(container: self, ptr: header.__begin_node)
    }
}

