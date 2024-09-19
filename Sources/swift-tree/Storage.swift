import Foundation

class RedBlackTreeStorage<Element: Comparable> {
    
    public init() { }
    
    @usableFromInline
    var header: RedBlackTreeHeader = .init()
    @usableFromInline
    var nodes: [RedBlackTreeNode] = []
    @usableFromInline
    var values: [Element] = []
    
    @inlinable
    public func reserveCapacity(_ minimumCapacity: Int) {
        nodes.reserveCapacity(minimumCapacity)
        values.reserveCapacity(minimumCapacity)
    }
}

extension RedBlackTreeStorage {
    
    @inlinable
    @inline(__always)
    func _update<R>(_ body: (_UnsafeUpdateHandle<Element>) throws -> R) rethrows -> R {
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
