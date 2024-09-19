import Foundation

@frozen
@usableFromInline
struct RedBlackTreeHeader {
    
    @inlinable
    @inline(__always)
    init() { }
    
    @usableFromInline
    var __left_: _NodePtr = .nullptr
    
    @usableFromInline
    var __begin_node: _NodePtr = .end
    
    @usableFromInline
    var size: Int = 0
}

