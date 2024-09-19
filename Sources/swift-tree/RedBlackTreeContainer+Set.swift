import Foundation

typealias RedBlackTreeContainer = RedBlackTree.Container

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
    mutating func remove(at ptr: _NodePtr) -> Element? {
        ptr == .end ? nil : erase__(ptr)
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
            var it = $0.__upper_bound(p, $0.__root(), .end)
            if it == .end { return nil }
            if p == $0.__value_ptr[it] {
                it = $0.__tree_next_iter(it)
            }
            return it != .end ? $0.__value_ptr[it] : nil
        }
    }
    
    @inlinable
    func left(_ p: Element) -> Ptr2<Element> {
        let it = _read { $0.__lower_bound(p, $0.__root(), .end) }
        return .init(container: self, ptr: it)
    }
    
    @inlinable
    func right(_ p: Element) -> Ptr2<Element> {
        let it = _read { $0.__upper_bound(p, $0.__root(), .end) }
        return .init(container: self, ptr: it)
    }

    @inlinable
    public var count: Int { header.size }
    
    @inlinable
    public var isEmpty: Bool { count == 0 }
    
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
    
    subscript(index: Int) -> Element {
        var p = header.__begin_node
        return _read {
            for _ in 0 ..< index {
                p = $0.__tree_next_iter(p)
            }
            return $0.__value_(p)
        }
    }
    
    func index(of ptr: _NodePtr) -> Int {
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
    
    @inlinable
    public init<S>(_ _a: S) where S: Collection, S.Element == Element {
        self.init()
        for a in _a {
            _ = __insert_unique(a)
        }
    }
}

public struct Ptr2<Element: Comparable> {
    @inlinable
    init(container: RedBlackTree.Container<Element>, ptr: _NodePtr, offset: Int = 0) {
        self.container = container
        self.ptr = ptr
        self.offset = offset
    }
    @usableFromInline
    var container: RedBlackTree.Container<Element>
    @usableFromInline
    let ptr: _NodePtr
    @usableFromInline
    var offset: Int = 0
    var index: Int { container.index(of: ptr) }
}

public struct Ptr {
    @inlinable
    init(ptr: _NodePtr, offset: Int = 0) {
        self.ptr = ptr
        self.offset = offset
    }
    @usableFromInline
    let ptr: _NodePtr
    @usableFromInline
    var offset: Int = 0
}
