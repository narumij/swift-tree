import Foundation

extension ValueProtocol {

    @inlinable
    func
    __lower_bound(_ __v: Element,_ __root: _NodePtr,_ __result: _NodePtr) -> _NodePtr
    {
        var __root = __root
        var __result = __result
        
        while (__root != .nullptr)
        {
            if (!value_comp(__value_(__root), __v)) {
                __result = __root
                __root = __left_(__root)
            }
            else {
                __root = __right_(__root) }
        }
        return __result
    }
    
    @inlinable
    func
    __upper_bound(_ __v: Element,_ __root: _NodePtr,_ __result: _NodePtr) -> _NodePtr
    {
        var __root = __root
        var __result = __result

        while (__root != .nullptr)
        {
            if (value_comp(__v, __value_(__root)))
            {
                __result = __root
                __root = __left_(__root) }
            else {
                __root = __right_(__root) }
        }
        return __result
    }
}
