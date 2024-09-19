import Foundation

@usableFromInline
protocol NodeFindProtocol
: ValueProtocol
& RootProtocol
& EndNodeProtocol
& EndProtocol
{ }

@usableFromInline
protocol NodeFindEtcProtocol
: NodeFindProtocol
& RefProtocol
& RootPtrProrototol
& EndNodeProtocol { }

extension NodeFindEtcProtocol {
    @inlinable
    @inline(__always)
    func
    addressof(_ p: _NodeRef) -> _NodeRef { p }
    
    @inlinable
    @inline(__always)
    func
    static_cast__node_pointer(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable
    @inline(__always)
    func
    static_cast__parent_pointer(_ p: _NodePtr) -> _NodePtr { p }
}

extension NodeFindEtcProtocol {
    
    @inlinable
    @inline(__always)
    func
    __find_equal(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef
    {
        var __nd     = __root()
        var __nd_ptr = __root_ptr()
        if (__nd != .nullptr) {
            while (true) {
                if (value_comp(__v, __value_(__nd))) {
                    if (__left_(__nd) != .nullptr) {
                        __nd_ptr = addressof(__left_ref(__nd))
                        __nd     = static_cast__node_pointer(__left_(__nd))
                    } else {
                        __parent = static_cast__parent_pointer(__nd)
                        return __left_ref(__parent)
                    }
                } else if (value_comp(__value_(__nd), __v)) {
                    if (__right_(__nd) != .nullptr) {
                        __nd_ptr = addressof(__right_ref(__nd))
                        __nd     = static_cast__node_pointer(__right_(__nd))
                    } else {
                        __parent = static_cast__parent_pointer(__nd)
                        return __right_ref(__nd)
                    }
                } else {
                    __parent = static_cast__parent_pointer(__nd)
                    return __nd_ptr
                }
            }
        }
        __parent = static_cast__parent_pointer(__end_node())
        return __left_ref(__parent)
    }
}

extension NodeFindProtocol {
    
    @inlinable
    func find(_ __v: Element) -> _NodePtr {
        let __p = __lower_bound(__v, __root(), __end_node())
        if (__p != end() && !value_comp(__v, __value_(__p))) {
            return __p }
        return end()
    }
}

