import Foundation

public struct _Node {
    
    @inlinable
    init(__is_black_: Bool, __left_: _NodePtr, __right_: _NodePtr, __parent_: _NodePtr) {
        self.__is_black_ = __is_black_
        self.__left_ = __left_
        self.__right_ = __right_
        self.__parent_ = __parent_
    }
    
    @usableFromInline
    var __is_black_: Bool
    @usableFromInline
    var __left_  : _NodePtr
    @usableFromInline
    var __right_ : _NodePtr
    @usableFromInline
    var __parent_: _NodePtr
    
    @inlinable
    mutating func clear() {
        __is_black_ = false
        __parent_   = .nullptr
        __left_     = .nullptr
        __right_    = .nullptr
    }
}

extension _Node: Equatable { }

