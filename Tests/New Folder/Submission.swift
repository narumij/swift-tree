//
//  RemoveProtocol.swift
//  swift-tree
//
//  Created by narumij on 2024/09/20.
//


import Foundation
//import Algorithms
//import Collections
//import AtCoder

fileprivate let main: () = {
    do { try Answer() } catch { /* WA */ }
}()

public func Answer() throws {
    let (H,W,Q): Int3 = Input.read()
    var g1: [RedBlackTreeSet<Int>] = [.init()] * H
    var g2: [RedBlackTreeSet<Int>] = [.init()] * W

#if false
    for i in 0..<H {
        g1[i].reserveCapacity(W)
    }
    for j in 0..<W {
        g2[j].reserveCapacity(H)
    }

    for i in 0..<H {
        for j in 0..<W {
            _ = g1[i].insert(j)
            _ = g2[j].insert(i)
        }
    }
#else
    for i in 0..<H {
        g1[i] = .init(0..<W)
    }
    for j in 0..<W {
        g2[j] = .init(0..<H)
    }
#endif

    func erase(_ i: Int,_ j: Int) {
        _ = g1[i].remove(j)
        _ = g2[j].remove(i)
    }
    
    Q.rep {
        let (R, C): Int2 = (.read() - 1, .read() - 1)
        
        if g1[R].contains(C) {
            erase(R, C)
            return
        }
        
        do {
            let it = g2[C].lower_bound(R)
            if it != g2[C].begin() {
                erase(g2[C][it, offsetBy: -1], C)
            }
        }

        do {
            let it = g2[C].lower_bound(R)
            if it != g2[C].end() {
                erase(g2[C][it], C)
            }
        }
        
        do {
            let it = g1[R].lower_bound(C)
            if it != g1[R].begin() {
                erase(R, g1[R][it, offsetBy: -1])
            }
        }

        do {
            let it = g1[R].lower_bound(C)
            if it != g2[C].end() {
                erase(R, g1[R][it])
            }
        }
    }
    
    var ans = 0
    for i in 0..<H {
        ans += g1[i].count
    }
    
    print(ans)
}





// MARK: - 以下連結

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
import Foundation

@usableFromInline
protocol RemoveProtocol
: MemberSetProtocol
& BeginNodeProtocol
& EndNodeProtocol
& SizeProtocol
{ }

extension RemoveProtocol {
    
    @inlinable
    func next(_ p: _NodePtr) -> _NodePtr {
        __tree_next_iter(p)
    }
    
    @inlinable
    func __ptr_(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable
    func iterator(_ p: _NodePtr) -> _NodePtr { p }

    @inlinable
    func static_cast__node_base_pointer(_ p: _NodePtr) -> _NodePtr { p }

    @inlinable
    func __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr {
        var __r = iterator(__ptr)
        __r = next(__r)
        if (__begin_node == __ptr) {
            __begin_node = __ptr_(__r) }
        size -= 1
        __tree_remove(__left_(__end_node()), static_cast__node_base_pointer(__ptr))
        return __r
    }
}
import Foundation

@usableFromInline
protocol FindLeafEtcProtocol
: ValueProtocol
& RootProtocol
& RefProtocol
& EndNodeProtocol { }

extension FindLeafEtcProtocol {
    
    @inlinable
    func
    __find_leaf_low(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef
    {
        var __nd: _NodePtr = __root();
        if __nd != .nullptr {
            while true {
                if value_comp(__value_(__nd), __v) {
                    if __right_(__nd) != .nullptr {
                        __nd = __right_(__nd); }
                    else {
                        __parent = __nd;
                        return __right_ref(__nd);
                    }
                } else {
                    if __left_(__nd) != .nullptr {
                        __nd = __left_(__nd); }
                    else {
                        __parent = __nd;
                        return __left_ref(__parent);
                    }
                }
            }
        }
        __parent = __end_node();
        return __left_ref(__parent);
    }
    
    @inlinable
    func
    __find_leaf_high(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef
    {
        var __nd: _NodePtr = __root()
        if __nd != .nullptr {
            while true
            {
                if value_comp(__v, __value_(__nd))
                {
                    if __left_(__nd) != .nullptr {
                        __nd = __left_(__nd) }
                    else {
                        __parent = __nd
                        return __left_ref(__parent)
                    }
                }
                else
                {
                    if __right_(__nd) != .nullptr {
                        __nd = __right_(__nd) }
                    else {
                        __parent = __nd
                        return __right_ref(__nd)
                    }
                }
            }
        }
        __parent = __end_node()
        return __left_ref(__parent)
    }
}

@usableFromInline
protocol NodeFindEtcProtocol
: NodeFindProtocol
& RefProtocol
& RootPtrProrototol { }

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

@usableFromInline
protocol NodeFindProtocol
: ValueProtocol
& RootProtocol
& EndNodeProtocol
& EndProtocol
{ }

extension NodeFindProtocol {
    
    @inlinable
    func find(_ __v: Element) -> _NodePtr {
        let __p = __lower_bound(__v, __root(), __end_node())
        if (__p != end() && !value_comp(__v, __value_(__p))) {
            return __p }
        return end()
    }
}

import Foundation

public
typealias _NodePtr = Int

extension _NodePtr {
    @inlinable
    static var nullptr: Self { -2 }
    @inlinable
    static var end: Self { -1 }
    @inlinable
    static func node(_ p: Int) -> Self { p }
}

public
enum _NodeRef: Equatable {
    case nullptr
    case __right_(_NodePtr)
    case __left_(_NodePtr)
}

@usableFromInline
protocol MemberProtocol {
    func __parent_(_: _NodePtr) -> _NodePtr
    func __left_(_: _NodePtr) -> _NodePtr
    func __right_(_: _NodePtr) -> _NodePtr
    func __is_black_(_: _NodePtr) -> Bool
    func __parent_unsafe(_: _NodePtr) -> _NodePtr
}

@usableFromInline
protocol MemberSetProtocol: MemberProtocol {
    func __is_black_(_ lhs: _NodePtr,_ rhs: Bool)
    func __parent_(_ lhs: _NodePtr,_ rhs: _NodePtr)
    func __left_(_ lhs: _NodePtr,_ rhs: _NodePtr)
    func __right_(_ lhs: _NodePtr,_ rhs: _NodePtr)
}

@usableFromInline
protocol RefProtocol: MemberProtocol {
    func __left_ref(_: _NodePtr) -> _NodeRef
    func __right_ref(_: _NodePtr) -> _NodeRef
    func __ref_(_ rhs: _NodeRef) -> _NodePtr
}

@usableFromInline
protocol RefSetProtocol: RefProtocol {
    func __ref_(_ lhs: _NodeRef,_ rhs: _NodePtr)
}

@usableFromInline
protocol ValueProtocol: MemberProtocol {
    
    associatedtype Element
    func __value_(_: _NodePtr) -> Element
    func value_comp(_:Element,_:Element) -> Bool
}

extension ValueProtocol where Element: Comparable {
    @inlinable
    func value_comp(_ a: Element,_ b: Element) -> Bool { a < b }
}

@usableFromInline
protocol BeginNodeProtocol {
    var __begin_node: _NodePtr { get nonmutating set }
}

@usableFromInline
protocol RootProtocol {
    func __root() -> _NodePtr
}

@usableFromInline
protocol RootPtrProrototol {
    func __root_ptr() -> _NodeRef
}

@usableFromInline
protocol EndNodeProtocol {
    func __end_node() -> _NodePtr
}

extension EndNodeProtocol {
    @inlinable
    @inline(__always)
    func __end_node() -> _NodePtr { .end }
}

@usableFromInline
protocol EndProtocol {
    func end() -> _NodePtr
}

extension EndProtocol {
    @inlinable
    @inline(__always)
    func end() -> _NodePtr { .end }
}

@usableFromInline
protocol SizeProtocol {
    var size: Int { get nonmutating set }
}

import Foundation

extension MemberProtocol {
    
    @inlinable func
    static_cast_EndNodePtr(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable func
    static_cast_NodePtr(_ p: _NodePtr) -> _NodePtr { p }
}

extension MemberProtocol {
    
    @inlinable
    @inline(__always)
    func
    __tree_is_left_child(_ __x: _NodePtr) -> Bool
    {
        return __x == __left_(__parent_(__x))
    }
    
    @inlinable
    func
    __tree_sub_invariant(_ __x: _NodePtr) -> UInt
    {
        if (__x == .nullptr) {
            return 1 }
        // parent consistency checked by caller
        // check __x->__left_ consistency
        if (__left_(__x) != .nullptr && __parent_(__left_(__x)) != __x) {
            return 0 }
        // check __x->__right_ consistency
        if (__right_(__x) != .nullptr && __parent_(__right_(__x)) != __x) {
            return 0 }
        // check __x->__left_ != __x->__right_ unless both are nullptr
        if (__left_(__x) == __right_(__x) && __left_(__x) != .nullptr) {
            return 0 }
        // If this is red, neither child can be red
        if (!__is_black_(__x)) {
            if (__left_(__x) != .nullptr && !__is_black_(__left_(__x))) {
                return 0 }
            if (__right_(__x) != .nullptr && !__is_black_(__right_(__x))) {
                return 0 }
        }
        let __h = __tree_sub_invariant(__left_(__x));
        if (__h == 0) {
            return 0 } // invalid left subtree
        if (__h != __tree_sub_invariant(__right_(__x))) {
            return 0 }                   // invalid or different height right subtree
        return __h + (__is_black_(__x) ? 1 : 0) // return black height of this node
    }
    
    @inlinable
    func
    __tree_invariant(_ __root: _NodePtr) -> Bool
    {
        if (__root == .nullptr) {
            return true; }
        // check __x->__parent_ consistency
        if (__parent_(__root) == .nullptr) {
            return false; }
        if (!__tree_is_left_child(__root)) {
            return false; }
        // root must be black
        if (!__is_black_(__root)) {
            return false; }
        // do normal node checks
        return __tree_sub_invariant(__root) != 0;
    }
    
    @inlinable
    func
    __tree_min(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "Root node shouldn't be null");
        var __x = __x
        while (__left_(__x) != .nullptr) {
            __x = __left_(__x) }
        return __x
    }
    
    @inlinable
    func
    __tree_max(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "Root node shouldn't be null");
        var __x = __x
        while (__right_(__x) != .nullptr) {
            __x = __right_(__x) }
        return __x
    }
    
    @inlinable
    func
    __tree_next(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "node shouldn't be null");
        var __x = __x
        if (__right_(__x) != .nullptr) {
            return __tree_min(__right_(__x)) }
        while (!__tree_is_left_child(__x)) {
            __x = __parent_unsafe(__x) }
        return __parent_unsafe(__x)
    }
    
    @inlinable
    func
    __tree_next_iter(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "node shouldn't be null")
        var __x = __x
        if (__right_(__x) != .nullptr) {
            return static_cast_EndNodePtr(__tree_min(__right_(__x))) }
        while (!__tree_is_left_child(__x)) {
            __x = __parent_unsafe(__x) }
        return static_cast_EndNodePtr(__parent_(__x))
    }
    
    @inlinable
    func
    __tree_prev_iter(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "node shouldn't be null")
        if (__left_(__x) != .nullptr) {
            return __tree_max(__left_(__x)) }
        var __xx = static_cast_NodePtr(__x)
        while (__tree_is_left_child(__xx)) {
            __xx = __parent_unsafe(__xx) }
        return __parent_unsafe(__xx)
    }
    
    @inlinable
    func
    __tree_leaf(_ __x: _NodePtr) -> _NodePtr
    {
        assert(__x != .nullptr, "node shouldn't be null");
        var __x = __x
        while true {
            if __left_(__x) != .nullptr {
                __x = __left_(__x)
                continue
            }
            if __right_(__x) != .nullptr {
                __x = __right_(__x)
                continue
            }
            break
        }
        return __x
    }
}

import Foundation

@usableFromInline
protocol EraseProtocol : StorageProtocol & EndProtocol {
    mutating func find(_ __v: Element) -> _NodePtr
    mutating func __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr
}

extension EraseProtocol {
    
    @inlinable
    func __get_np(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable
    mutating func
    erase(_ __p: _NodePtr) -> _NodePtr
    {
        let __np    = __get_np(__p)
        let __r     = __remove_node_pointer(__np)
        destroy(__p)
        return __r
    }
    
    @inlinable
    mutating func
    __erase_unique(_ __k: Element) -> Bool {
        let __i = find(__k)
        if (__i == end()) {
            return false }
        _ = erase(__i)
        return true
    }
}

import Foundation

@usableFromInline
protocol NodeInsertProtocol
: MemberSetProtocol
& RefSetProtocol
& SizeProtocol
& BeginNodeProtocol
& EndNodeProtocol
{ }

extension NodeInsertProtocol {
    
    @inlinable
    func
    static_cast__iter_pointer(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable
    func __tree_balance_after_insert(_ lhs: _NodePtr,_ rhs: _NodeRef) {
        __tree_balance_after_insert(lhs, __ref_(rhs))
    }
}

extension NodeInsertProtocol {
    
    @inlinable
    func
    __insert_node_at(
        _ __parent: _NodePtr, _ __child: _NodeRef,
        _ __new_node: _NodePtr)
    {
        __left_(__new_node, .nullptr)
        __right_(__new_node, .nullptr)
        __parent_(__new_node, __parent)
        // __new_node->__is_black_ is initialized in __tree_balance_after_insert
        __ref_(__child, __new_node)
        if (__left_(__begin_node) != .nullptr) {
            __begin_node = static_cast__iter_pointer(__left_(__begin_node))
        }
        __tree_balance_after_insert(__left_(__end_node()), __child)
        size += 1
    }
}


@usableFromInline
protocol StorageProtocol {
    
    associatedtype Element

    @inlinable
    mutating func __construct_node(_ k: Element) -> _NodePtr
    
    @inlinable
    mutating func destroy(_ p: _NodePtr)
}

@usableFromInline
protocol InsertUniqueProtocol: StorageProtocol {
    func __ref_(_ rhs: _NodeRef) -> _NodePtr
    mutating func
    __find_equal(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef
    mutating func
    __insert_node_at(
        _ __parent: _NodePtr, _ __child: _NodeRef,
        _ __new_node: _NodePtr)
}

extension InsertUniqueProtocol {
    
    @inlinable
    public mutating func __insert_unique(_ x: Element) -> (__r: _NodeRef, __inserted: Bool) {
        
        __emplace_unique_key_args(x)
    }

    @inlinable
    mutating func
    __emplace_unique_key_args(_ __k: Element) -> (__r: _NodeRef, __inserted: Bool)
    {
        var __parent   = _NodePtr.nullptr
        let __child    = __find_equal(&__parent, __k)
        let __r        = __child
        var __inserted = false
        if __ref_(__child) == .nullptr {
            let __h = __construct_node(__k)
            __insert_node_at(__parent, __child, __h)
            __inserted = true
        }
        return (__r, __inserted)
    }
}
import Foundation

extension MemberSetProtocol {
    
    @inlinable
    func
    __tree_left_rotate(_ __x: _NodePtr)
    {
        assert(__x != .nullptr, "node shouldn't be null");
        assert(__right_(__x) != .nullptr, "node should have a right child");
        let __y = __right_(__x)
        __right_(__x, __left_(__y))
        if (__right_(__x) != .nullptr) {
            __parent_(__right_(__x), __x) }
        __parent_(__y, __parent_(__x))
        if __tree_is_left_child(__x) {
            __left_(__parent_(__x), __y) }
        else {
            __right_(__parent_(__x), __y) }
        __left_(__y, __x)
        __parent_(__x, __y)
    }
    
    @inlinable
    func
    __tree_right_rotate(_ __x: _NodePtr)
    {
        assert(__x != .nullptr, "node shouldn't be null");
        assert(__left_(__x) != .nullptr, "node should have a left child");
        let __y = __left_(__x)
        __left_(__x, __right_(__y))
        if (__left_(__x) != .nullptr) {
            __parent_(__left_(__x), __x) }
        __parent_(__y, __parent_(__x))
        if __tree_is_left_child(__x) {
            __left_(__parent_(__x), __y) }
        else {
            __right_(__parent_(__x), __y) }
        __right_(__y, __x)
        __parent_(__x, __y)
    }
    
    @inlinable
    func
    __tree_balance_after_insert(_ __root: _NodePtr, _ __x: _NodePtr)
    {
        assert(__root != .nullptr, "Root of the tree shouldn't be null");
        assert(__x != .nullptr, "Can't attach null node to a leaf");
        var __x = __x
        __is_black_(__x, __x == __root)
        while (__x != __root && !__is_black_(__parent_unsafe(__x))) {
          // __x->__parent_ != __root because __x->__parent_->__is_black == false
            if (__tree_is_left_child(__parent_unsafe(__x))) {
                let __y = __right_(__parent_unsafe(__parent_unsafe(__x)))
                if (__y != .nullptr && !__is_black_(__y)) {
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, true)
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, __x == __root)
                    __is_black_(__y, true)
                } else {
                    if (!__tree_is_left_child(__x)) {
                        __x            = __parent_unsafe(__x)
                        __tree_left_rotate(__x)
                    }
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, true)
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, false)
                    __tree_right_rotate(__x)
                    break
                }
            } else {
                let __y = __left_(__parent_(__parent_unsafe(__x)))
                if (__y != .nullptr && !__is_black_(__y)) {
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, true)
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, __x == __root)
                    __is_black_(__y, true)
                } else {
                    if (__tree_is_left_child(__x)) {
                        __x            = __parent_unsafe(__x)
                        __tree_right_rotate(__x)
                    }
                    __x            =  __parent_unsafe(__x)
                    __is_black_(__x, true)
                    __x            = __parent_unsafe(__x)
                    __is_black_(__x, false)
                    __tree_left_rotate(__x)
                    break
                }
            }
        }
    }
    
    @inlinable
    func
    __tree_remove(_ __root: _NodePtr,_ __z: _NodePtr)
    {
        assert(__root != .nullptr, "Root node should not be null")
        assert(__z != .nullptr, "The node to remove should not be null")
        assert(__tree_invariant(__root), "The tree invariants should hold");
        var __root = __root
        // __z will be removed from the tree.  Client still needs to destruct/deallocate it
        // __y is either __z, or if __z has two children, __tree_next(__z).
        // __y will have at most one child.
        // __y will be the initial hole in the tree (make the hole at a leaf)
        let __y = (__left_(__z) == .nullptr || __right_(__z) == .nullptr) ?
        __z : __tree_next(__z)
        // __x is __y's possibly null single child
        var __x = __left_(__y) != .nullptr ? __left_(__y) : __right_(__y)
        // __w is __x's possibly null uncle (will become __x's sibling)
        var __w: _NodePtr = .nullptr
        // link __x to __y's parent, and find __w
        if (__x != .nullptr) {
            __parent_(__x, __parent_(__y)) }
        if (__tree_is_left_child(__y))
        {
            __left_(__parent_(__y), __x)
            if (__y != __root) {
                __w = __right_(__parent_(__y)) }
            else {
                __root = __x }  // __w == nullptr
        }
        else
        {
            __right_(__parent_(__y), __x)
            // __y can't be root if it is a right child
            __w = __left_(__parent_(__y))
        }
        let __removed_black = __is_black_(__y)
        // If we didn't remove __z, do so now by splicing in __y for __z,
        //    but copy __z's color.  This does not impact __x or __w.
        if (__y != __z)
        {
            // __z->__left_ != nulptr but __z->__right_ might == __x == nullptr
            __parent_(__y, __parent_(__z))
            if (__tree_is_left_child(__z)) {
                __left_(__parent_(__y), __y) }
            else {
                __right_(__parent_(__y), __y) }
            __left_(__y, __left_(__z))
            __parent_(__left_(__y), __y)
            __right_(__y, __right_(__z))
            if (__right_(__y) != .nullptr) {
                __parent_(__right_(__y), __y) }
            __is_black_(__y, __is_black_(__z))
            if (__root == __z) {
                __root = __y }
        }
        // There is no need to rebalance if we removed a red, or if we removed
        //     the last node.
        if (__removed_black && __root != .nullptr)
        {
            // Rebalance:
            // __x has an implicit black color (transferred from the removed __y)
            //    associated with it, no matter what its color is.
            // If __x is __root (in which case it can't be null), it is supposed
            //    to be black anyway, and if it is doubly black, then the double
            //    can just be ignored.
            // If __x is red (in which case it can't be null), then it can absorb
            //    the implicit black just by setting its color to black.
            // Since __y was black and only had one child (which __x points to), __x
            //   is either red with no children, else null, otherwise __y would have
            //   different black heights under left and right pointers.
            // if (__x == __root || __x != nullptr && !__x->__is_black_)
            if (__x != .nullptr) {
                __is_black_(__x, true) }
            else
            {
                //  Else __x isn't root, and is "doubly black", even though it may
                //     be null.  __w can not be null here, else the parent would
                //     see a black height >= 2 on the __x side and a black height
                //     of 1 on the __w side (__w must be a non-null black or a red
                //     with a non-null black child).
                while (true)
                {
                    if (!__tree_is_left_child(__w))  // if x is left child
                    {
                        if (!__is_black_(__w))
                        {
                            __is_black_(__w, true)
                            __is_black_(__parent_(__w), false)
                            __tree_left_rotate(__parent_(__w))
                            // __x is still valid
                            // reset __root only if necessary
                            if (__root == __left_(__w)) {
                                __root = __w }
                            // reset sibling, and it still can't be null
                            __w = __right_(__left_(__w))
                        }
                        // __w->__is_black_ is now true, __w may have null children
                        if ((__left_(__w)  == .nullptr || __is_black_(__left_(__w))) &&
                            (__right_(__w) == .nullptr || __is_black_(__right_(__w))))
                        {
                            __is_black_(__w, false)
                            __x = __parent_(__w)
                            // __x can no longer be null
                            if (__x == __root || !__is_black_(__x))
                            {
                                __is_black_(__x, true)
                                break
                            }
                            // reset sibling, and it still can't be null
                            __w = __tree_is_left_child(__x) ?
                            __right_(__parent_(__x)) :
                            __left_(__parent_(__x))
                            // continue;
                        }
                        else  // __w has a red child
                        {
                            if (__right_(__w) == .nullptr || __is_black_(__right_(__w)))
                            {
                                // __w left child is non-null and red
                                __is_black_(__left_(__w), true)
                                __is_black_(__w, false)
                                __tree_right_rotate(__w)
                                // __w is known not to be root, so root hasn't changed
                                // reset sibling, and it still can't be null
                                __w = __parent_(__w)
                            }
                            // __w has a right red child, left child may be null
                            __is_black_(__w, __is_black_(__parent_(__w)))
                            __is_black_(__parent_(__w), true)
                            __is_black_(__right_(__w), true)
                            __tree_left_rotate(__parent_(__w))
                            break
                        }
                    }
                    else
                    {
                        if (!__is_black_(__w))
                        {
                            __is_black_(__w, true)
                            __is_black_(__parent_(__w), false)
                            __tree_right_rotate(__parent_(__w))
                            // __x is still valid
                            // reset __root only if necessary
                            if (__root == __right_(__w)) {
                                __root = __w }
                            // reset sibling, and it still can't be null
                            __w = __left_(__right_(__w))
                        }
                        // __w->__is_black_ is now true, __w may have null children
                        if ((__left_(__w)  == .nullptr || __is_black_(__left_(__w))) &&
                            (__right_(__w) == .nullptr || __is_black_(__right_(__w))))
                        {
                            __is_black_(__w, false)
                            __x = __parent_(__w)
                            // __x can no longer be null
                            if (!__is_black_(__x) || __x == __root)
                            {
                                __is_black_(__x, true)
                                break
                            }
                            // reset sibling, and it still can't be null
                            __w = __tree_is_left_child(__x) ?
                            __right_(__parent_(__x)) :
                            __left_(__parent_(__x))
                            // continue;
                        }
                        else  // __w has a red child
                        {
                            if (__left_(__w) == .nullptr || __is_black_(__left_(__w)))
                            {
                                // __w right child is non-null and red
                                __is_black_(__right_(__w), true)
                                __is_black_(__w, false)
                                __tree_left_rotate(__w)
                                // __w is known not to be root, so root hasn't changed
                                // reset sibling, and it still can't be null
                                __w = __parent_(__w)
                            }
                            // __w has a left red child, right child may be null
                            __is_black_(__w, __is_black_(__parent_(__w)))
                            __is_black_(__parent_(__w), true)
                            __is_black_(__left_(__w), true)
                            __tree_right_rotate(__parent_(__w))
                            break
                        }
                    }
                }
            }
        }
    }
}
import Foundation

extension RedBlackTree {
    
    @frozen
    @usableFromInline
    struct Header {
        
        @inlinable
        @inline(__always)
        init() { }
        
        @usableFromInline
        var __left_: _NodePtr = .nullptr
        
        @usableFromInline
        var __begin_node: _NodePtr = .end
        
        @usableFromInline
        var size: Int = 0
        
        @usableFromInline
        static let zero: Self = .init()
    }
}

import Foundation

public enum RedBlackTree { }

import Foundation

public
extension RedBlackTree.Container {
    @inlinable @inline(__always)
    init<S>(_ _a: S) where S: Collection, S.Element == Element {
//        self.header = .zero
//        self.nodes = []
//        self.values = []
        var _values: [Element] = _a + []
        var _header: RedBlackTree.Header = .zero
        let _nodes = Array<RedBlackTree.Node>(unsafeUninitializedCapacity: _values.count, initializingWith: { _nodes, initializedCount in
            
            initializedCount = 0

            withUnsafeMutablePointer(to: &_header) { _header in
                _values.withUnsafeMutableBufferPointer { _values in
                    let tree = _UnsafeUpdateHandle<Element>(
                        __header_ptr: _header,
                        __node_ptr: _nodes.baseAddress!,
                        __value_ptr: _values.baseAddress!)
                    
                    func ___construct_node(_ __k: Element) -> _NodePtr {
                        _nodes[initializedCount] = .zero
                        _values[initializedCount] = __k
                        defer { initializedCount += 1 }
                        return initializedCount
                    }
                    
                    _a.forEach { __k in
                        
                        var __parent   = _NodePtr.nullptr
                        let __child    = tree.__find_equal(&__parent, __k)
                        if tree.__ref_(__child) == .nullptr {
                            let __h = ___construct_node(__k)
                            tree.__insert_node_at(__parent, __child, __h)
                        }
                    }
                }
            }
        })
        self.header = _header
        self.nodes = _nodes
        self.values = _values
    }
    
    @inlinable
    var count: Int { header.size }
    
    @inlinable
    var isEmpty: Bool { count == 0 }
}

extension RedBlackTree.Container {
    @inlinable
    @discardableResult
    public mutating func insert(_ p: Element) -> Bool {
        __insert_unique(p).__inserted
    }
    @inlinable
    @discardableResult
    public mutating func remove(_ p: Element) -> Bool {
        __erase_unique(p)
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
}

extension RedBlackTree.Container {

    public typealias Pointer = _NodePtr

    @inlinable
    public func begin() -> _NodePtr {
        __begin_node
    }
    
    @inlinable
    public func end() -> _NodePtr {
        .end
    }
    
    @inlinable
    public mutating func remove(at ptr: _NodePtr) -> Element? {
        ptr == .end ? nil : erase__(ptr)
    }
    
    @inlinable
    public func lower_bound(_ p: Element) -> _NodePtr {
        _read { $0.__lower_bound(p, $0.__root(), .end) }
    }
    
    @inlinable
    public func upper_bound(_ p: Element) -> _NodePtr {
        _read { $0.__upper_bound(p, $0.__root(), .end) }
    }

    @inlinable
    public subscript(node: _NodePtr) -> Element {
        values[node]
    }

    @inlinable
    public subscript(node: _NodePtr, offsetBy distance: Int) -> Element {
        element(node, offsetBy: distance)!
    }
    
    @inlinable func element(_ ptr: _NodePtr, offsetBy distance: Int) -> Element? {
        let ptr = pointer(ptr, offsetBy: distance)
        return ptr == .end ? nil : values[ptr]
    }

    @inlinable func pointer(_ ptr: _NodePtr, offsetBy distance: Int) -> _NodePtr {
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

import Foundation

extension RedBlackTree {
    
    @frozen
    public struct Container<Element: Comparable> {
        
        @inlinable @inline(__always)
        public init() {
            header = .zero
            nodes = []
            values = []
        }
        
        @inlinable
        public init(minimumCapacity: Int) {
            header = .zero
            nodes = []
            values = []
            nodes.reserveCapacity(minimumCapacity)
            values.reserveCapacity(minimumCapacity)
        }
        
        @usableFromInline
        var header: Header
        @usableFromInline
        var nodes: [Node]
        @usableFromInline
        var values: [Element]
        
#if false
        @usableFromInline
        var stock: [_NodePtr] = []
#endif
        
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
#if false
        if let stock = stock.popLast() {
            return stock
        }
#endif
        let n = values.count
        nodes.append(.zero)
        values.append(k)
        return n
    }
    
    @inlinable
    mutating func destroy(_ p: _NodePtr) {
#if false
        stock.append(p)
#endif
    }
    
    @inlinable func __left_(_ p: _NodePtr) -> _NodePtr {
        p == .end ? header.__left_ : nodes[p].__left_
    }
    @inlinable func __right_(_ p: _NodePtr) -> _NodePtr {
        nodes[p].__right_
    }
    @inlinable func __ref_(_ rhs: _NodeRef) -> _NodePtr {
        switch rhs {
        case .nullptr:
            return .nullptr
        case .__right_(let basePtr):
            return __right_(basePtr)
        case .__left_(let basePtr):
            return __left_(basePtr)
        }
    }
    
    @inlinable mutating func
    __find_equal(_ __parent: inout _NodePtr, _ __v: Element) -> _NodeRef {
        _update{ $0.__find_equal(&__parent, __v) }
    }
    
    @inlinable mutating func
    __insert_node_at(_ __parent: _NodePtr, _ __child: _NodeRef, _ __new_node: _NodePtr) {
        _update{ $0.__insert_node_at(__parent, __child, __new_node) }
    }
    
    @inlinable mutating func
    __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr {
        _update{ $0.__remove_node_pointer(__ptr) }
    }
}

public extension RedBlackTree.Container {
    
    @inlinable mutating func
    find(_ __v: Element) -> _NodePtr {
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
import Foundation

extension RedBlackTree {
    
    public struct Node {
        
        @usableFromInline
        var __right_ : _NodePtr
        @usableFromInline
        var __left_  : _NodePtr
        @usableFromInline
        var __parent_: _NodePtr
        @usableFromInline
        var __is_black_: Bool
        
        @inlinable
        mutating func clear() {
            __right_    = .nullptr
            __left_     = .nullptr
            __parent_   = .nullptr
            __is_black_ = false
        }
        
        @inlinable
        init(__is_black_: Bool, __left_: _NodePtr = .nullptr, __right_: _NodePtr = .nullptr, __parent_: _NodePtr = .nullptr) {
            self.__right_ = __right_
            self.__left_ = __left_
            self.__parent_ = __parent_
            self.__is_black_ = __is_black_
        }
        
        @usableFromInline
        static let zero: Self = .init(__is_black_: false)
    }
}

extension RedBlackTree.Node: Equatable { }
import Foundation

public typealias RedBlackTreeSet = RedBlackTree.Container
import Foundation

@usableFromInline
protocol ReadHandleImpl: MemberProtocol & ValueProtocol & RootImpl & RefImpl & RootPtrImpl {
    associatedtype Element
    var __header_ptr: UnsafePointer<RedBlackTree.Header> { get }
    var __node_ptr: UnsafePointer<RedBlackTree.Node>{ get }
    var __value_ptr: UnsafePointer<Element>{ get }
}

extension ReadHandleImpl {
    
    @inlinable
    @inline(__always)
    var __left_: _NodePtr {
        __header_ptr.pointee.__left_
    }
    
    @inlinable
    @inline(__always)
    var __begin_node: _NodePtr {
        __header_ptr.pointee.__begin_node
    }
    
    @inlinable
    @inline(__always)
    var size: Int {
        __header_ptr.pointee.size
    }
}

extension ReadHandleImpl {
    
    @inlinable
    @inline(__always)
    func __parent_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__parent_
    }
    @inlinable
    @inline(__always)
    func __left_(_ p: _NodePtr) -> _NodePtr {
        p == .end ? __left_ : __node_ptr[p].__left_
    }
    @inlinable
    @inline(__always)
    func __right_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__right_
    }
    @inlinable
    @inline(__always)
    func __is_black_(_ p: _NodePtr) -> Bool {
        __node_ptr[p].__is_black_
    }
    @inlinable
    @inline(__always)
    func __parent_unsafe(_ p: _NodePtr) -> _NodePtr {
        __parent_(p)
    }
}

extension ReadHandleImpl {
    @inlinable
    @inline(__always)
    func __value_(_ p: _NodePtr) -> Element { __value_ptr[p] }
}
import Foundation

@usableFromInline
protocol UpdateHandleImpl: RefSetImpl & RootImpl & RootPtrImpl {
    associatedtype Element
    var __header_ptr: UnsafeMutablePointer<RedBlackTree.Header> { get }
    var __node_ptr: UnsafeMutablePointer<RedBlackTree.Node>{ get }
    var __value_ptr: UnsafeMutablePointer<Element>{ get }
}

extension UpdateHandleImpl {
    
    @inlinable
    var __left_: _NodePtr {
        @inline(__always) get { __header_ptr.pointee.__left_ }
        nonmutating set { __header_ptr.pointee.__left_ = newValue }
    }
    
    @inlinable
    var __begin_node: _NodePtr {
        @inline(__always) get { __header_ptr.pointee.__begin_node }
        nonmutating set { __header_ptr.pointee.__begin_node = newValue }
    }
    
    @inlinable
    var size: Int {
        @inline(__always) get { __header_ptr.pointee.size }
        nonmutating set { __header_ptr.pointee.size = newValue }
    }
}

extension UpdateHandleImpl {
    
    @inlinable
    @inline(__always)
    func __parent_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__parent_
    }
    @inlinable
    @inline(__always)
    func __left_(_ p: _NodePtr) -> _NodePtr {
        p == .end ? __left_ : __node_ptr[p].__left_
    }
    @inlinable
    @inline(__always)
    func __right_(_ p: _NodePtr) -> _NodePtr {
        __node_ptr[p].__right_
    }
    @inlinable
    @inline(__always)
    func __is_black_(_ p: _NodePtr) -> Bool {
        __node_ptr[p].__is_black_
    }
    @inlinable
    @inline(__always)
    func __parent_unsafe(_ p: _NodePtr) -> _NodePtr {
        __parent_(p)
    }
}

extension UpdateHandleImpl {

    @inlinable
    func __is_black_(_ lhs: _NodePtr,_ rhs: Bool) {
        __node_ptr[lhs].__is_black_ = rhs
    }
    @inlinable
    func __parent_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        __node_ptr[lhs].__parent_ = rhs
    }
    @inlinable
    func __left_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        if lhs == .end {
            __left_ = rhs
        }
        else {
            __node_ptr[lhs].__left_ = rhs
        }
    }
    @inlinable
    func __right_(_ lhs: _NodePtr,_ rhs: _NodePtr) {
        __node_ptr[lhs].__right_ = rhs
    }
}

extension UpdateHandleImpl {
    
    @inlinable
    @inline(__always)
    func __value_(_ p: _NodePtr) -> Element { __value_ptr[p] }
}

import Foundation

@usableFromInline
protocol RefImpl: MemberProtocol { }

extension RefImpl {
    
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
    func __left_ref(_ p: _NodePtr) -> _NodeRef {
        .__left_(p)
    }
    
    @inlinable
    func __right_ref(_ p: _NodePtr) -> _NodeRef {
        .__right_(p)
    }
}

@usableFromInline
protocol RefSetImpl: MemberSetProtocol & RefImpl { }

extension RefSetImpl {
    
    @inlinable
    func __ref_(_ lhs: _NodeRef,_ rhs: _NodePtr) {
        switch lhs {
        case .nullptr:
            fatalError()
        case .__right_(let basePtr):
            return __right_(basePtr, rhs)
        case .__left_(let basePtr):
            return __left_(basePtr, rhs)
        }
    }

}

@usableFromInline
protocol RootImpl: MemberProtocol & EndNodeProtocol { }

extension RootImpl {
    @inlinable
    @inline(__always)
    func __root() -> _NodePtr { __left_(__end_node()) }
}

@usableFromInline
protocol RootPtrImpl: RefProtocol & EndNodeProtocol { }

extension RootPtrImpl {
    @inlinable
    func __root_ptr() -> _NodeRef { __left_ref(__end_node()) }
}
import Foundation

@frozen
@usableFromInline
struct _UnsafeReadHandle<Element: Comparable> {
    
    @inlinable
    @inline(__always)
    init(__header_ptr: UnsafePointer<RedBlackTree.Header>,
         __node_ptr: UnsafePointer<RedBlackTree.Node>,
         __value_ptr: UnsafePointer<Element>) {
        self.__header_ptr = __header_ptr
        self.__node_ptr = __node_ptr
        self.__value_ptr = __value_ptr
    }
    @usableFromInline
    let __header_ptr: UnsafePointer<RedBlackTree.Header>
    @usableFromInline
    let __node_ptr: UnsafePointer<RedBlackTree.Node>
    @usableFromInline
    let __value_ptr: UnsafePointer<Element>
}

extension _UnsafeReadHandle: ReadHandleImpl { }
extension _UnsafeReadHandle: NodeFindProtocol & NodeFindEtcProtocol & FindLeafEtcProtocol { }
import Foundation

@frozen
@usableFromInline
struct _UnsafeUpdateHandle<Element: Comparable> {
    
    @inlinable
    @inline(__always)
    init(__header_ptr: UnsafeMutablePointer<RedBlackTree.Header>,
         __node_ptr: UnsafeMutablePointer<RedBlackTree.Node>,
         __value_ptr: UnsafeMutablePointer<Element>) {
        self.__header_ptr = __header_ptr
        self.__node_ptr = __node_ptr
        self.__value_ptr = __value_ptr
    }
    @usableFromInline
    let __header_ptr: UnsafeMutablePointer<RedBlackTree.Header>
    @usableFromInline
    let __node_ptr: UnsafeMutablePointer<RedBlackTree.Node>
    @usableFromInline
    let __value_ptr: UnsafeMutablePointer<Element>
}

extension _UnsafeUpdateHandle: UpdateHandleImpl { }
extension _UnsafeUpdateHandle: NodeFindProtocol & NodeFindEtcProtocol { }
extension _UnsafeUpdateHandle: NodeInsertProtocol { }
extension _UnsafeUpdateHandle: RemoveProtocol { }
import Foundation

// MARK: - Read

public protocol SingleRead {
    @inlinable @inline(__always)
    static func read() -> Self
}

public protocol TupleRead: SingleRead { }
public protocol ArrayRead: SingleRead { }
public protocol FullRead: ArrayRead & TupleRead { }

public extension Collection where Element: ArrayRead {
    @inlinable @inline(__always)
    static func read(columns: Int) -> [Element] {
        (0..<columns).map{ _ in Element.read() }
    }
    @inlinable @inline(__always)
    static func read(rows: Int) -> [Element] {
        (0..<rows).map{ _ in Element.read() }
    }
}

public extension Collection where Element: Collection, Element.Element: ArrayRead {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[Element.Element]] {
        (0..<rows).map{ _ in Element.read(columns: columns) }
    }
}

extension Int: FullRead { }
extension UInt: FullRead { }
extension Double: FullRead { }
extension CInt: FullRead { }
extension CUnsignedInt: FullRead { }
extension CLongLong: FullRead { }
extension CUnsignedLongLong: FullRead { }

extension String: TupleRead { }
extension Character: TupleRead { }
extension UInt8: TupleRead { }

public extension FixedWidthInteger {
    @inlinable @inline(__always) static func read() -> Self { .init(ATOL.read()!) }
}

public extension BinaryFloatingPoint {
    @inlinable @inline(__always) static func read() -> Self { .init(ATOF.read()!) }
}

public extension String {
    @inlinable @inline(__always)
    static func read() -> String { ATOS.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> String { ATOS.read(columns: columns) }
}

public extension Array where Element == String {
    
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [String] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

public extension UInt8 {
    static func read() -> UInt8 { ATOB.read(columns: 1).first! }
}

public extension Array where Element == UInt8 {
    @inlinable @inline(__always)
    static func read() -> [UInt8] { ATOB.read() }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [UInt8] { ATOB.read(columns: columns) }
}

public extension Array where Element == Array<UInt8> {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[UInt8]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

public extension Character {
    static func read() -> Character { Character(String.read(columns: 1)) }
}

public extension Array where Element == Character {
    @inlinable @inline(__always)
    static func read() -> [Character] {
        String.read().map{ $0 }
    }
    
    @inlinable @inline(__always)
    static func read(columns: Int) -> [Character] {
        String.read(columns: columns).map{ $0 }
    }
}

public extension Array where Element == Array<Character> {
    @inlinable @inline(__always)
    static func read(rows: Int, columns: Int) -> [[Character]] {
        (0..<rows).map { _ in .read(columns: columns) }
    }
}

@usableFromInline protocol IOReader { }

@usableFromInline protocol FixedBufferIOReader: IOReader {
    var buffer: [UInt8] { get set }
}

extension FixedWidthInteger {
    @inlinable @inline(__always) static var SP: Self { 0x20 }
    @inlinable @inline(__always) static var LF: Self { 0x0A }
}

extension FixedWidthInteger {
    
    @inlinable @inline(__always)
    static func __readHead() -> Self {
        var head: Self
        repeat {
            head = numericCast(getchar_unlocked())
        } while head == .SP || head == .LF;
        return head
    }
}

extension Array where Element: FixedWidthInteger {
    
    @inlinable @inline(__always)
    static func __readBytes(count: Int) -> Self? {
        let h: Element = .__readHead()
        guard h != EOF else { return nil }
        return [h] + (1..<count).map { _ in numericCast(getchar_unlocked()) }
    }
}

extension FixedBufferIOReader {
    
    @inlinable @inline(__always)
    mutating func _next<T>(_ f: (UnsafePointer<UInt8>) -> T) -> T? {
        var current = 0
        return buffer.withUnsafeMutableBufferPointer { buffer in
            buffer.baseAddress![current] = .__readHead()
            while buffer.baseAddress![current] != .SP,
                  buffer.baseAddress![current] != .LF,
                  buffer.baseAddress![current] != EOF
            {
                current += 1
                buffer[current] = numericCast(getchar_unlocked())
            }
            return current == 0 ? nil : f(buffer.baseAddress!)
        }
    }
}

@usableFromInline protocol VariableBufferIOReader: IOReader {
    associatedtype BufferElement: FixedWidthInteger
    var buffer: [BufferElement] { get set }
}

extension VariableBufferIOReader {
    @inlinable @inline(__always)
    mutating func _next<T>(_ f: (UnsafeBufferPointer<BufferElement>, Int) -> T?) -> T? {
        var current = 0
        buffer[current] = .__readHead()
        while buffer[current] != .SP, buffer[current] != .LF, buffer[current] != 0 {
            current += 1
            if current == buffer.count {
                buffer.append(contentsOf: repeatElement(0, count: buffer.count))
            }
            buffer[current] = BufferElement(truncatingIfNeeded: getchar_unlocked())
        }
        return buffer.withUnsafeBufferPointer{ f($0, current) }
    }
}

@usableFromInline protocol IOReaderInstance: IteratorProtocol {
    static var instance: Self { get set }
}

extension IOReaderInstance {
    @inlinable @inline(__always) static func read() -> Element! { instance.next() }
}

@usableFromInline struct ATOL: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Int? { _next { atol($0) } }
    public static var instance = Self()
}

@usableFromInline struct ATOF: IteratorProtocol, FixedBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 64)
    @inlinable @inline(__always)
    public mutating func next() -> Double? { _next { atof($0) } }
    public static var instance = Self()
}

@usableFromInline struct ATOB: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer: [UInt8] = .init(repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> Array<UInt8>? { _next { Array($0[0..<$1]) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> [UInt8] {
        defer { getchar_unlocked() }
        return .__readBytes(count: columns) ?? []
    }
}

@usableFromInline struct ATOS: IteratorProtocol, VariableBufferIOReader, IOReaderInstance {
    public var buffer = [UInt8](repeating: 0, count: 32)
    @inlinable @inline(__always)
    public mutating func next() -> String? { _next { b,c in String(bytes: b[0..<c], encoding: .ascii) } }
    public static var instance = Self()
    @inlinable @inline(__always) static func read(columns: Int) -> String! {
        defer { getchar_unlocked() }
        return String(bytes: Array.__readBytes(count: columns) ?? [], encoding: .ascii)
    }
}
import Foundation

struct Pair<A: Hashable,B: Hashable>: Hashable {
    init(_ a: A,_ b: B) { (self.a, self.b) = (a,b) }
    init(_ ab: (A, B)) { (self.a, self.b) = ab }
    var a: A
    var b: B
}
import Foundation

// MARK: - dijkstra

enum Dijkstra {
    
    enum Error: Swift.Error {
        case cycle
    }
    
    struct _edge<Cost: Comparable & AdditiveArithmetic>: Comparable {
        @inlinable @inline(__always)
        init(to: Int, cost: Cost) {
            self.to = to
            self.cost = cost
        }
        @inlinable @inline(__always)
        init(_ pair: (Int, Cost)) {
            (self.to, self.cost) = pair
        }
        let to: Int
        let cost: Cost
        @inlinable @inline(__always)
        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.cost < rhs.cost || (lhs.cost == rhs.cost && lhs.to < rhs.to)
        }
    }

    static func dijkstra<Cost: Comparable & AdditiveArithmetic>(_ graph: [[(to: Int, cost: Cost)]], to: Int, INF: Cost) -> [Cost] {
        var dist = [Cost](repeating: INF, count: graph.count)
        var visited = [false] * graph.count
        dist[to] = .zero
        var queue = PriorityQueue([_edge<Cost>(to: to, cost: .zero)])
        while let now = queue.popMin() {
            let u = now.to
            if visited[u] { continue }
            visited[u] = true
            for (v, weight) in graph[u] {
                if !visited[v], dist[u] + weight < dist[v] {
                    dist[v] = dist[u] + weight
                    queue.insert(.init(to: v, cost: dist[v]))
                }
            }
        }
        return dist;
    }
    
    static func distances(_ graph: [[Int]], to: Int, INF: Int) -> [Int] {
        var dist = [Int](repeating: Int.max, count: graph.count)
        var visited = [false] * graph.count
        dist[to] = .zero
        var queue = PriorityQueue([_edge<Int>(to: to, cost: .zero)])
        let cost = 1
        while let now = queue.popMin() {
            let u = now.to
            if visited[u] { continue }
            visited[u] = true
            for v in graph[u] {
                let weight = cost
                if !visited[v], dist[u] + weight < dist[v] {
                    dist[v] = dist[u] + weight
                    queue.insert(.init(to: v, cost: dist[v]))
                }
            }
        }
        return dist;
    }
    
    static func distances(pos_to: [[Int:Int]], to: Int, INF: Int) -> [Int] {
        var dist = [Int](repeating: INF, count: pos_to.count)
        dist[to] = .zero
        var queue = PriorityQueue([_edge<Int>(to: to, cost: .zero)])
        while let now = queue.popMin() {
            if dist[now.to] < now.cost { continue }
            for e in pos_to[now.to] {
                if dist[e.key] > now.cost + e.value {
                    dist[e.key] = now.cost + e.value
                    queue.insert(.init(to: e.key, cost: now.cost + e.value))
                }
            }
        }
        return dist;
    }
    
    static func distances(pos_to: [[Int]], cost: [[Int]], to: Int, INF: Int) -> [Int] {
        var dist = [Int](repeating: Int.max, count: pos_to.count)
        var visited = [false] * pos_to.count
        dist[to] = .zero
        var queue = PriorityQueue([_edge<Int>(to: to, cost: .zero)])
        while let now = queue.popMin() {
            let u = now.to
            if visited[u] { continue }
            visited[u] = true
            for v in pos_to[u] {
                let weight = cost[u][v]
                if !visited[v], dist[u] + weight < dist[v] {
                    dist[v] = dist[u] + weight
                    queue.insert(.init(to: v, cost: dist[v]))
                }
            }
        }
        return dist;
    }
    
    static func route<Cost: Comparable & AdditiveArithmetic>(_ graph: [[(to: Int, cost: Cost)]], from: Int, to: Int, INF: Cost, dist: [Cost]) throws -> [Int] {
        var visited = [false] * graph.count
        var result = [Int]()
        var pos = from
        visited[from] = true
        while pos != to {
            pos = graph[pos].first{ dist[$0.to] == dist[pos] - $0.cost }!.to
            if visited[pos] {
                throw Dijkstra.Error.cycle
            }
            result.append(pos)
            visited[pos] = true
        }
        return result
    }
    
    static func route(_ graph: [[Int:Int]], from: Int, to: Int, INF: Int, dist: [Int]) throws -> [Int] {
        var visited = [false] * graph.count
        var result = [Int]()
        var pos = from
        visited[from] = true
        while pos != to {
            pos = graph[pos].sorted(by: { $0.key < $1.key }).first{ dist[$0.key] == dist[pos] - $0.value }!.key
            if visited[pos] {
                throw Dijkstra.Error.cycle
            }
            result.append(pos)
            visited[pos] = true
        }
        return result
    }
    
    static func route(pos_to: [[Int]], from: Int, to: Int, dist: [Int]) throws -> [Int] {
        var visited = [false] * pos_to.count
        var result = [Int]()
        var pos = from
        visited[from] = true
        while pos != to {
            pos = pos_to[pos].first{ dist[$0] == dist[pos] - 1 }!
            if visited[pos] {
                throw Dijkstra.Error.cycle
            }
            result.append(pos)
            visited[pos] = true
        }
        return result
    }
    
    static func route(pos_to: [[Int]], cost: [[Int]], dist: [Int], from: Int, to: Int) throws -> [Int] {
        var visited = [false] * pos_to.count
        var result = [Int]()
        var pos = from
        visited[from] = true
        while pos != to {
            pos = pos_to[pos].first{ dist[$0] == dist[pos] - cost[pos][$0] }!
            if visited[pos] {
                throw Dijkstra.Error.cycle
            }
            result.append(pos)
            visited[pos] = true
        }
        return result
    }
    
    static func path<Cost: Comparable & AdditiveArithmetic>(_ graph: [[(to: Int, cost: Cost)]], from: Int, to: Int, INF: Cost) throws -> [Int] {
        if graph[from].contains(where: { $0.to == to }) {
            return [to]
        }
        let dist = dijkstra(graph, to: to, INF: INF)
        return try route(graph, from: from, to: to, INF: INF, dist: dist)
    }
    
    static func path(_ graph: [[Int:Int]], from: Int, to: Int, INF: Int) throws -> [Int] {
        if graph[from][to, default: 0] > 0 {
            return [to]
        }
        let dist = distances(pos_to: graph, to: to, INF: INF)
        return try route(graph, from: from, to: to, INF: INF, dist: dist)
    }
    
    static func path(_ graph: [[Int]], from: Int, to: Int, INF: Int) throws -> [Int] {
        if graph[from].contains(to) {
            return [to]
        }
        let dist = distances(graph, to: to, INF: INF)
        return try route(pos_to: graph, from: from, to: to, dist: dist)
    }
    
    static func path(_ pos_to: [[Int]], cost: [[Int]], from: Int, to: Int, INF: Int) throws -> (path: [Int], cost: Int) {
        if pos_to[from].contains(to) {
            return ([to], cost[from][to])
        }
        let dist = distances(pos_to: pos_to, cost: cost, to: to, INF: INF)
        return try (route(pos_to: pos_to, cost: cost, dist: dist, from: from, to: to), dist[from])
    }
}

//
//  File.swift
//  AtCoderBeginner
//
//  Created by narumij on 2024/08/12.
//

import Foundation

/// 累積和1D
func cum<T>(_ A: [T]) -> [T] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
    let N = A.count
    var s: [T] = [0] * (N + 1)
    for i in 0 ..< N {
        s[i + 1] =
        s[i]
        + A[i]
    }
    return s
}

/// 累積和2D
func cum<T>(_ A: [[T]]) -> [[T]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
    let N = A.count
    let M = A[0].count
    assert(A.allSatisfy{ $0.count == M })
    var s: [[T]] = [0] * (N + 1, M + 1)
    for i in 0 ..< N {
        for j in 0 ..< M {
            s[i + 1][j + 1] =
            s[i + 1][j]
            + s[i][j + 1]
            - s[i][j]
            + A[i][j]
        }
    }
    return s
}

/// 累積和3D
func cum<T>(_ A: [[[T]]]) -> [[[T]]] where T: AdditiveArithmetic, T: ExpressibleByIntegerLiteral {
    let N = A.count
    let M = A[0].count
    let L = A[0][0].count
    assert(A.allSatisfy{ $0.count == M })
    assert(A.allSatisfy{ $0.allSatisfy{ $0.count == L } })
    var s: [[[T]]] = [0] * (N + 1, M + 1, L + 1)
    for i in 0..<N {
        for j in 0..<M {
            for k in 0..<L {
                s[i + 1][j + 1][k + 1] =
                s[i + 1][j + 1][k]
                + s[i + 1][j][k + 1]
                + s[i][j + 1][k + 1]
                - s[i + 1][j][k]
                - s[i][j + 1][k]
                - s[i][j][k + 1]
                + s[i][j][k]
                + A[i][j][k]
            }
        }
    }
    return s
}
import Foundation

// MARK: - STDERR

extension UnsafeMutablePointer: TextOutputStream where Pointee == FILE {
    public mutating func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        _ = data.withUnsafeBytes { bytes in
#if os(Linux)
            Glibc.write(fileno(self), bytes.baseAddress!, data.count)
#else
            Darwin.write(fileno(self), bytes.baseAddress!, data.count)
#endif
        }
    }
}

import Foundation

// MARK: - Heap

extension Array: BinaryHeap {
    @inlinable @inline(__always)
    mutating func __update_binary_heap<R>(_ comp: @escaping (Element, Element) -> Bool,
                             _ body: (BinaryHeapUnsafeHandle<Element>) -> R) -> R {
        body(BinaryHeapUnsafeHandle(&self, startIndex: startIndex, endIndex: endIndex, comp))
    }
}

protocol BinaryHeap: Sequence {
    @inlinable @inline(__always)
    mutating func __update_binary_heap<R>(_ comp: @escaping (Element, Element) -> Bool,
                                          _ body: (BinaryHeapUnsafeHandle<Element>) -> R) -> R
}

extension BinaryHeap {
    mutating func make_heap(_ end: Int,_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.make_heap(end) }
    }
    mutating func push_heap(_ end: Int,_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.push_heap(end) }
    }
    mutating func pop_heap(_ comp: @escaping (Element, Element) -> Bool) {
        __update_binary_heap(comp) { $0.pop_heap($0.endIndex) }
    }
}

extension Int {
    // https://en.wikipedia.org/wiki/Binary_heap
    @inlinable @inline(__always)
    var parent:     Int { (self - 1) >> 1 }
    @inlinable @inline(__always)
    var leftChild:  Int { (self << 1) + 1 }
    @inlinable @inline(__always)
    var rightChild: Int { (self << 1) + 2 }
}

@usableFromInline
struct BinaryHeapUnsafeHandle<Element> {
    @inlinable @inline(__always)
    internal init(_ buffer: UnsafeMutablePointer<Element>,
                  startIndex: Int, endIndex: Int,
                  _ comp: @escaping (Element, Element) -> Bool)
    {
        self.buffer = buffer
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.comp = comp
    }
    @usableFromInline
    let buffer: UnsafeMutablePointer<Element>
    @usableFromInline
    let comp: (Element, Element) -> Bool
    @usableFromInline
    let startIndex: Int
    @usableFromInline
    let endIndex: Int
}

extension BinaryHeapUnsafeHandle {
    @usableFromInline
    typealias Index = Int
    
    @inlinable @inline(__always)
    func push_heap(_ limit: Index) {
        heapifyUp(limit, limit - 1, comp)
    }
    @inlinable @inline(__always)
    func pop_heap(_ limit: Index) {
        guard limit > 0, startIndex != limit - 1 else { return }
        swap(&buffer[startIndex], &buffer[limit - 1])
        heapifyDown(limit - 1, startIndex, comp)
    }
    @inlinable @inline(__always)
    func heapifyUp(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        guard i >= startIndex else { return }
        let element = buffer[i]
        var current = i
        while current > startIndex {
            let parent = current.parent
            guard !comp(buffer[parent], element) else { break }
            (buffer[current], current) = (buffer[parent], parent)
        }
        buffer[current] = element
    }
    @inlinable @inline(__always)
    func heapifyDown(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        let element = buffer[i]
        var (current, selected) = (i,i)
        while current < limit {
            let leftChild = current.leftChild
            let rightChild = leftChild + 1
            if leftChild < limit,
               comp(buffer[leftChild], element)
            {
                selected = leftChild
            }
            if rightChild < limit,
               comp(buffer[rightChild], current == selected ? element : buffer[selected])
            {
                selected = rightChild
            }
            if selected == current { break }
            (buffer[current], current) = (buffer[selected], selected)
        }
        buffer[current] = element
    }
    private func heapify(_ limit: Index,_ i: Index,_ comp: (Element, Element) -> Bool) {
        guard let index = heapifyIndex(limit, i, comp) else { return }
        swap(&buffer[i],&buffer[index])
        heapify(limit, index, comp)
    }
    private func heapifyIndex(_ limit: Index,_ current: Index,_ comp: (Element, Element) -> Bool) -> Index? {
        var next = current
        if current.leftChild < limit,
           comp(buffer[current.leftChild], buffer[next])
        {
            next = current.leftChild
        }
        if current.rightChild < limit,
           comp(buffer[current.rightChild], buffer[next])
        {
            next = current.rightChild
        }
        return next == current ? nil : next
    }
    func isHeap(_ limit: Index) -> Bool {
        (startIndex..<limit).allSatisfy{ heapifyIndex(limit, $0, comp) == nil }
    }
    func make_heap(_ limit: Index) {
        for i in stride(from: limit / 2, through: startIndex, by: -1) {
            heapify(limit, i, comp)
        }
        assert(isHeap(limit))
    }
}
import Foundation

// MARK: - Inlined Collections

public protocol ArrayStorage {
    associatedtype Element
    associatedtype Buffer
    static var bytes: Buffer { get }
}

/// とっても危険なので、よい子のみんなはまねしないように。
public struct StackOrHeapArray<Storage: ArrayStorage> {
    public typealias Element = Storage.Element
    public typealias Buffer = Storage.Buffer
    public var buffer: Buffer
    public var count: Int
    
    @usableFromInline init() {
        buffer = Storage.bytes
        count = 0
    }
    
    @usableFromInline var inlineCount: Int { MemoryLayout<Buffer>.size }
    @usableFromInline var capacity: Int { inlineCount / MemoryLayout<Element>.stride }
    
    public var first: Element? { count == 0 ? nil : self[0] }

    @inlinable @inline(__always)
    func _read<R>(_ body: (UnsafeBufferPointer<Element>) -> R) -> R {
        withUnsafeBytes(of: buffer) { buffer in
            buffer.withMemoryRebound(to: Element.self) {
                body(UnsafeBufferPointer(start: $0.baseAddress, count: capacity))
            }
        }
    }

    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (UnsafeMutableBufferPointer<Element>) -> R) -> R {
        var buffer = buffer
        let result = withUnsafeMutableBytes(of: &buffer) { buffer in
            buffer.withMemoryRebound(to: Element.self) {
                body(UnsafeMutableBufferPointer(start: $0.baseAddress, count: capacity))
            }
        }
        self.buffer = buffer
        return result
    }
    
    @inlinable @inline(__always)
    public subscript(index: Int) -> Element {
        get {
            _read { buffer in
                buffer[index]
            }
        }
        set {
            guard index < capacity else { return }
            _update{ buffer in
                buffer[index] = newValue
            }
        }
    }
    
    @inlinable @inline(__always)
    public mutating func bubbleSort(by comparer: (Element, Element) -> Bool) {
        let count = count
        _update { buffer in
            for i in 0..<count {
                for j in 1..<(count -  i) {
                    if comparer(buffer[j], buffer[j - 1]) {
                        buffer.swapAt(j, j - 1)
                    }
                }
            }
        }
    }
    
    @inlinable @inline(__always)
    mutating func append(keyValue: Element) {
        self[count] = keyValue
        count += 1
    }

    @inlinable @inline(__always)
    func prefix(_ upTo: Int) -> Self {
        var result = Self()
        for i in 0..<min(count, upTo) {
            result.append(keyValue: self[i])
        }
        return result
    }

    @inlinable @inline(__always)
    func prefix(_ upTo: Int, orderBy comparer: (Element,Element) -> Bool) -> Self {
        var source = self
        source.bubbleSort(by: comparer)
        return source.prefix(2)
    }
}

public protocol DictionaryStorage {
    associatedtype Key: Equatable
    associatedtype Value
    associatedtype Buffer
    static var bytes: Buffer { get }
}

/// とっても危険なので、よい子のみんなはまねしないように。
public struct StackOrHeapDictionay<Storage: DictionaryStorage> {
    public typealias Key = Storage.Key
    public typealias Value = Storage.Value
    public typealias Element = (key: Key, value: Value)
    public typealias Buffer = Storage.Buffer
    public var buffer: Buffer
    public var count: Int
    
    @usableFromInline init() {
        buffer = Storage.bytes
        count = 0
    }
    
    @usableFromInline var inlineCount: Int { MemoryLayout<Buffer>.size }
    @usableFromInline var capacity: Int { inlineCount / MemoryLayout<Element>.stride }
    
    public var first: Element? { count == 0 ? nil : self[raw: 0] }

    @inlinable @inline(__always)
    func _read<R>(_ body: (UnsafeBufferPointer<Element>) -> R) -> R {
        withUnsafeBytes(of: buffer) { buffer in
            buffer.withMemoryRebound(to: Element.self) {
                body(UnsafeBufferPointer(start: $0.baseAddress, count: capacity))
            }
        }
    }

    @inlinable @inline(__always)
    mutating func _update<R>(_ body: (UnsafeMutableBufferPointer<Element>) -> R) -> R {
        var buffer = buffer
        let result = withUnsafeMutableBytes(of: &buffer) { buffer in
            buffer.withMemoryRebound(to: Element.self) {
                body(UnsafeMutableBufferPointer(start: $0.baseAddress, count: capacity))
            }
        }
        self.buffer = buffer
        return result
    }
    
    @inlinable @inline(__always)
    public subscript(raw index: Int) -> Element {
        get {
            _read { buffer in
                buffer[index]
            }
        }
        set {
            guard index < capacity else { return }
            _update{ buffer in
                buffer[index] = newValue
            }
        }
    }
    
    @inlinable @inline(__always)
    public mutating func bubbleSort(by comparer: (Element, Element) -> Bool) {
        let count = count
        _update { buffer in
            for i in 0..<count {
                for j in 1..<(count -  i) {
                    if comparer(buffer[j], buffer[j - 1]) {
                        buffer.swapAt(j, j - 1)
                    }
                }
            }
        }
    }
    
    @inlinable @inline(__always)
    mutating func append(keyValue: Element) {
        self[raw: count] = keyValue
        count += 1
    }
    
    @inlinable @inline(__always)
    static func index(buffer: UnsafeBufferPointer<Element>, count: Int, of k: Key) -> Int? {
        for i in 0..<count {
            if buffer[i].key == k {
                return i
            }
        }
        return nil
    }

    @inlinable @inline(__always)
    static func index(buffer: UnsafeMutableBufferPointer<Element>, count: Int, of k: Key) -> Int? {
        for i in 0..<count {
            if buffer[i].key == k {
                return i
            }
        }
        return nil
    }

    @inlinable subscript(key: Key) -> Value? {
        @inline(__always) get {
            _read {
                guard let i = Self.index(buffer: $0, count: count, of: key)
                else { return nil }
                return $0[i].value
            }
        }
        @inline(__always) set {
            if let newValue {
                let count = count
                let inserted: Bool = _update {
                    guard let i = Self.index(buffer: $0, count: count, of: key)
                    else { return false }
                    $0[i].value = newValue
                    return true
                }
                if inserted {
                    return
                }
                append(keyValue: (key: key, value: newValue))
            } else {
                /* remove */
            }
        }
    }
    @inlinable subscript(key: Key, default value: Value) -> Value {
        @inline(__always) get { self[key] ?? value }
        @inline(__always) set { self[key] = newValue }
    }

    @inlinable @inline(__always)
    func prefix(_ upTo: Int) -> Self {
        var result = Self()
        for i in 0..<min(count, upTo) {
            result.append(keyValue: self[raw: i])
        }
        return result
    }

    @inlinable @inline(__always)
    func prefix(_ upTo: Int, orderBy comparer: (Element,Element) -> Bool) -> Self {
        var source = self
        source.bubbleSort(by: comparer)
        return source.prefix(2)
    }
    
    @inlinable @inline(__always)
    func merging(_ other: Self) -> Self where Value: AdditiveArithmetic {
        var result = self
        other._read { rhs in
            for i in 0..<other.count {
                result[rhs[i].key, default: .zero] += rhs[i].value
            }
        }
        assert(result.count <= count + other.count)
        return result
    }
}

extension StackOrHeapDictionay: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        elements.forEach {
            self[$0.0] = $0.1
        }
    }
}
import Foundation

// MARK: - zip with

public func zip<A,B,C>(_ a: A,_ b: B, with f: (A.Element, B.Element) -> C) -> [C]
where A: Sequence, B: Sequence {
    var result = [C]()
    var (it0, it1) = (a.makeIterator(), b.makeIterator())
    while let x = it0.next(), let y = it1.next() {
        result.append(f(x,y))
    }
    return result
}

public func zip<A,B,C,D>(_ a: A,_ b: B,_ c: C, with f: (A.Element, B.Element, C.Element) -> D) -> [D]
where A: Sequence, B: Sequence, C: Sequence {
    var result = [D]()
    
    var it0 = a.makeIterator()
    var it1 = b.makeIterator()
    var it2 = c.makeIterator()
    
    while
        let x = it0.next(),
        let y = it1.next(),
        let z = it2.next()
    {
        result.append(f(x,y,z))
    }
    return result
}

public func zip<A,B,C,D,E>(_ a: A,_ b: B,_ c: C,_ d: D, with f: (A.Element, B.Element, C.Element, D.Element) -> E) -> [E]
where A: Sequence, B: Sequence, C: Sequence, D: Sequence {
    var result = [E]()
    
    var it0 = a.makeIterator()
    var it1 = b.makeIterator()
    var it2 = c.makeIterator()
    var it3 = d.makeIterator()
    
    while
        let x = it0.next(),
        let y = it1.next(),
        let z = it2.next(),
        let w = it3.next()
    {
        result.append(f(x,y,z,w))
    }
    return result
}

extension Array where Element: IteratorProtocol {
    fileprivate mutating func next() -> [Element.Element]? {
        indices
            .map { self[$0].next() }
            .reduce([]) { partial, item in
                guard let partial, let item else { return nil }
                return partial + [item]
            }
    }
}

extension Sequence where Element: Sequence {
    public func transposed() -> [[Element.Element]] {
        var result: [[Element.Element]] = []
        var iterators = map{ $0.makeIterator() }
        while let n = iterators.next() {
            result.append(n)
        }
        return result
    }
}
import Foundation

@inlinable
public func fold<A,B>(initial: A,_ f: (A,B) -> A,_ rest: B...) -> A {
    var result = initial
    for value in rest {
        result = f(result, value)
    }
    return result
}

extension SIMD {
    func reduce<T>(initial: T,_ f: (T, Scalar) -> T) -> T {
        var result = initial
        for index in 0 ..< Self.scalarCount {
            result = f(result, self[index])
        }
        return result
    }
}
import Foundation

// MARK: - Range Convinience

infix operator ..<=: RangeFormationPrecedence

public func ..<= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: 1)
}

infix operator ..>=: RangeFormationPrecedence

public func ..>= <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideThrough<Bound> {
    stride(from: lhs, through: rhs, by: -1)
}

infix operator ..>: RangeFormationPrecedence

public func ..> <Bound: Comparable>(lhs: Bound, rhs: Bound) -> StrideTo<Bound> {
    stride(from: lhs, to: rhs, by: -1)
}
import Foundation

struct SIMD4<Scalar: SIMDScalar> {
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    init(_ x: Scalar,_ y: Scalar,_ z: Scalar,_ w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    var x: Scalar
    var y: Scalar
    var z: Scalar
    var w: Scalar
}
extension SIMD4: Codable where Scalar: SIMDScalar { }
extension SIMD4: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
    init() { x = .zero; y = .zero; z = .zero; w = .zero }
}
extension SIMD4: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    typealias MaskStorage = SIMD4<Scalar.SIMDMaskScalar>
    subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            case 3: return w
            default: fatalError()
            }
        }
        set(newValue) {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            case 3: w = newValue
            default: fatalError()
            }
        }
    }
    var scalarCount: Int { 4 }
}
extension SIMD4: Equatable where Scalar: Equatable { }
extension SIMD4: Hashable where Scalar: Hashable { }
extension SIMD4: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Scalar...) {
        (x,y,z,w) = (elements[0], elements[1], elements[2], elements[3])
    }
}
extension SIMD4: CustomStringConvertible {
    var description: String { [x,y,z,w].description }
}
import Foundation

// MARK: - Integer

func floor(_ n: Int,_ d: Int) -> Int { (n - (n % d + d) % d) / d }
func ceil(_ n: Int,_ d: Int) -> Int { (n + (d - n % d) % d) / d }
func mod(_ n: Int,_ d: Int) -> Int { n < 0 ? n % d + d : n % d }
func lcm(_ a: Int,_ b: Int) -> Int { a / gcd(a,b) * b }
func gcd(_ a: Int,_ b: Int) -> Int {
    var (a,b) = (a,b)
    while a >= 1, b >= 1 {
        if a > b {
            a %= b
        } else {
            b %= a
        }
    }
    return a != 0 ? a : b
}
func factorial(_ n: Int) -> Int {
    if n <= 1 {
        return 1
    } else {
        return n * factorial(n - 1)
    }
}
import Foundation
import Algorithms

// MARK: - Vector

struct SIMD2<Scalar: SIMDScalar> {
    var x,y: Scalar
    init(x: Scalar, y: Scalar) { self.x = x; self.y = y }
    init(_ x: Scalar,_ y: Scalar) { self.x = x; self.y = y }
    init(_ v: [Scalar]) { (x,y) =  (v[0], v[1]) }
}
extension SIMD2: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Scalar...) {
        (x,y) = (elements[0], elements[1])
    }
}
extension SIMD2: Codable where Scalar: SIMDScalar { }
extension SIMD2: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
    init() { x = .zero; y = .zero }
}
extension SIMD2: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    typealias MaskStorage = SIMD2<Scalar.SIMDMaskScalar>
    subscript(index: Int) -> Scalar {
        get {
            index == 0 ? x : y
        }
        set(newValue) {
            x = index == 0 ? newValue : x
            y = index != 0 ? newValue : y
        }
    }
    var scalarCount: Int { 2 }
}
extension SIMD2: Equatable where Scalar: Equatable { }
extension SIMD2: Hashable where Scalar: Hashable { }
extension SIMD2: CustomStringConvertible {
    var description: String { [x,y].description }
}

extension SIMD2 where Scalar: FixedWidthInteger {
    func sum() -> Scalar { x + y }
}
func dot<Scalar>(_ lhs: SIMD2<Scalar>,_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    (lhs &* rhs).sum()
}
func dot<Scalar>(_ lhs: SIMD2<Scalar>,_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FloatingPoint {
    (lhs * rhs).sum()
}
func length_squared<Scalar>(_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    dot(rhs, rhs)
}
func length_squared<Scalar>(_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FloatingPoint {
    dot(rhs, rhs)
}
func distance_squared<Scalar>(_ lhs: SIMD2<Scalar>,_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    length_squared(lhs &- rhs)
}
func distance_squared<Scalar>(_ lhs: SIMD2<Scalar>,_ rhs: SIMD2<Scalar>) -> Scalar where Scalar: FloatingPoint {
    length_squared(lhs - rhs)
}

func triangle_area<Scalar>(_ a: SIMD2<Scalar>,_ b: SIMD2<Scalar>,_ c: SIMD2<Scalar>) -> Scalar where Scalar: Numeric {
    (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)
}

func min<T: Comparable>(_ a: SIMD2<T>,_ b: SIMD2<T>) -> SIMD2<T> {
    .init(min(a.x, b.x), min(a.y, b.y))
}

func max<T: Comparable>(_ a: SIMD2<T>,_ b: SIMD2<T>) -> SIMD2<T> {
    .init(max(a.x, b.x), max(a.y, b.y))
}

extension SIMD2 where Scalar == Int {
    //　Z-UP 右ネジ
    static var rotate90: [Self] { [[0,-1],[1,0]] }
    static var rotate180: [Self] { [[-1,0],[0,-1]] }
    static var rotate270: [Self] { [[0,1],[-1,0]] }
}

func mul<Scalar>(_ m: [[Scalar]],_ v: SIMD2<Scalar>) -> SIMD2<Scalar> where Scalar: FixedWidthInteger {
    // 行列がcolumn-majorなのかrow-majorなのか、いまいちわかっていない。
    // たまたまあってるレベル
    [(SIMD2(m[0]) &* v).sum(), (SIMD2(m[1]) &* v).sum()]
}

func &* <Component>(lhs: [[Component]], rhs: SIMD2<Component>) -> SIMD2<Component> where Component: FixedWidthInteger {
    mul(lhs, rhs)
}

func product(origin o: SIMD2<Int>, size s: SIMD2<Int>) -> [SIMD2<Int>] {
    product(o.x..<(o.x + s.x), o.y..<(o.y + s.y)).map { SIMD2<Int>(x: $0.0, y: $0.1) }
}

typealias VInt2 = SIMD2<Int>

extension SIMD2 {
    func reversed() -> Self { .init(y, x) }
}

func manhattanDistance<T>(_ lhs: SIMD2<T>,_ rhs: SIMD2<T>) -> T where T : SignedNumeric, T : Comparable {
    (0 ..< SIMD2<Int>.scalarCount).reduce(0) { $0 + abs(lhs[$1] - rhs[$1]) }
}
import Foundation

// MARK: - Priority Queue

public struct PriorityQueue<Element: Comparable> {
    @usableFromInline var elements: [Element] = []
}

public extension PriorityQueue {
    init<S>(_ elements: S) where S: Sequence, S.Element == Element {
        self.init(elements: elements.map{ $0 })
    }
}

extension PriorityQueue {
    @inlinable @inline(__always)
    mutating func __update<R>(_ body: (BinaryHeapUnsafeHandle<Element>) -> R) -> R {
        elements.__update_binary_heap(<, body)
    }
}

public extension PriorityQueue {
    mutating func insert(_ element:Element) {
        elements.append(element)
        __update { $0.push_heap($0.endIndex) }
    }
    @discardableResult
    mutating func popMin() -> Element? {
        guard !elements.isEmpty else { return nil }
        __update { $0.pop_heap($0.endIndex) }
        return elements.removeLast()
    }
    var isEmpty: Bool { elements.isEmpty }
    var first: Element? { elements.first }
    var count: Int { elements.count }
}
import Foundation

// MARK: - ReadHelper

typealias Int2 = (Int,Int)
typealias Int3 = (Int,Int,Int)
typealias Int4 = (Int,Int,Int,Int)
typealias Int5 = (Int,Int,Int,Int,Int)
typealias Int6 = (Int,Int,Int,Int,Int,Int)

public enum Input { }

public extension Input {
    
    @inlinable @inline(__always)
    static func read<A>() -> A! where A: SingleRead {
        .read()
    }
    
    static func read<A,B>() -> (A,B)!
    where A: TupleRead, B: TupleRead
    {
        (.read(), .read())
    }
    
    static func read<A,B,C>() -> (A,B,C)!
    where A: TupleRead, B: TupleRead, C: TupleRead
    {
        (.read(), .read(), .read())
    }
    
    static func read<A,B,C,D>() -> (A,B,C,D)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead
    {
        (.read(), .read(), .read(), .read())
    }
    
    static func read<A,B,C,D,E>() -> (A,B,C,D,E)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead
    {
        (.read(), .read(), .read(), .read(), .read())
    }
    
    static func read<A,B,C,D,E,F>() -> (A,B,C,D,E,F)!
    where A: TupleRead, B: TupleRead, C: TupleRead, D: TupleRead, E: TupleRead, F: TupleRead
    {
        (.read(), .read(), .read(), .read(), .read(), .read())
    }
}

extension Array where Element: RawRepresentable, Element.RawValue == UInt8 {
    static func read(columns: Int) -> [Element] {
        [UInt8].read(columns: columns)
            .compactMap(Element.init)
    }
}

extension Array where Element: Sequence, Element.Element: RawRepresentable, Element.Element.RawValue == UInt8 {
    static func read(rows: Int, columns: Int) -> [[Element.Element]] {
        [[UInt8]].read(rows: rows, columns: columns)
            .map {
                $0.compactMap(Element.Element.init)
            }
    }
}
import Foundation

// MARK: - Char Convinience

typealias Char = UInt8

extension UInt8: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: String) {
        self = value.utf8.first!
    }
}

extension UInt8 {
    var character: Character { Character(UnicodeScalar(self)) }
    var char: Character { character }
    func lowercased() -> Self {
        guard
            self >= 65,
            self <= 90
        else {
            return self
        }
        return self + 32
    }
    func uppercased() -> Self {
        guard
            self >= 97,
            self <= 122
        else {
            return self
        }
        return self - 32
    }
}

extension Sequence where Element == UInt8 {
    func joined() -> String { String(bytes: self, encoding: .ascii)! }
    var characters: [Character] { map(\.character) }
}

extension String {
    init<S>(ascii: S) where S: Sequence, S.Element == UInt8 {
        self = ascii.joined()
    }
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

// MARK: - Character Convinience

extension Character: Strideable {
    public func distance(to other: Character) -> Int {
        Int(other.asciiValue!) - Int(asciiValue!)
    }
    public func advanced(by n: Int) -> Character {
        Character(UnicodeScalar(UInt8(Int(asciiValue!) + n)))
    }
}

extension Character {
    var integerValue: Int { Character("0").distance(to: self) }
}

extension Sequence where Element == Character {
    func joined() -> String { String(self) }
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

extension String {
    var characters: [Character] { map{ $0 } }
}
import Foundation

// MARK: - Binary Search

extension Range where Bound == Int {
    
    @inlinable
    func left(_ lowerThan: (Bound) -> Bool) -> Bound {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if lowerThan(mid) {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    @inlinable
    func right(_ greaterThan: (Bound) -> Bool) -> Bound {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if greaterThan(mid) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
}

extension Range {

    @inlinable
    func left<Item>(_ x: Item,_ item: (Element) -> Item) -> Element where Item: Comparable, Bound: BinaryInteger {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if item(mid) < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    @inlinable
    func right<Item>(_ x: Item,_ item: (Element) -> Item) -> Element where Item: Comparable, Bound: BinaryInteger {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if x < item(mid) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
}

extension Collection where Index == Int {
    
    @inlinable
    func left(_ lowerThan: (Element) -> Bool) -> Index {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if lowerThan(self[mid]) {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    @inlinable
    func right(_ greaterThan: (Element) -> Bool) -> Index {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if greaterThan(self[mid]) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
    
    @inlinable
    func right(_ x: Element, start left: Index, end right: Index) -> Index where Element: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if x < self[mid] {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }
    
    @inlinable
    func right<T>(_ x: T, start left: Index, end right: Index,_ key: (Element) -> T) -> Index where T: Comparable {
        var (left, right) = (startIndex, endIndex)
        while left < right {
            let mid = (left + right) >> 1
            if x < key(self[mid]) {
                right = mid
            } else {
                left = mid + 1
            }
        }
        return left
    }

    @inlinable
    func left(_ x: Element, start left: Index, end right: Index) -> Index where Element: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if self[mid] < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
    
    @inlinable
    func left<T>(_ x: T, start left: Index, end right: Index,_ key: (Element) -> T) -> Index where T: Comparable {
        var (left, right) = (left, right)
        while left < right {
            let mid = (left + right) >> 1
            if key(self[mid]) < x {
                left = mid + 1
            } else {
                right = mid
            }
        }
        return left
    }
}

extension Collection where Index == Int, Element: Comparable {
    @inlinable
    func right(_ x: Element) -> Index { right(x, start: startIndex, end: endIndex) }
    @inlinable
    func left(_ x: Element) -> Index { left(x, start: startIndex, end: endIndex) }
}
import Foundation
import Algorithms

let INF: Int = 1 << 60
let MOD_998_244_353 = 998_244_353
let MOD_1_000_000_007 = 1_000_000_007

func Yes(_ b: Bool = true) -> String { b ? "Yes" : "No" }
func No(_ b: Bool = true) -> String { Yes(!b) }
func YES(_ b: Bool = true) -> String { b ? "YES" : "NO" }
func NO(_ b: Bool = true) -> String { YES(!b) }

func Takahashi(_ b: Bool = true) -> String { b ? "Takahashi" : "Aoki" }
func Aoki(_ b: Bool = true) -> String { Takahashi(!b) }

let snuke = "snuke"

// MARK: - Integer Convinience

precedencegroup PowerPrecedence {
    lowerThan: BitwiseShiftPrecedence
    higherThan: MultiplicationPrecedence
    associativity: right
    assignment: true
}

infix operator ** : PowerPrecedence

func ** <INT>(lhs: INT, rhs: Int) -> INT where INT: FixedWidthInteger {
    repeatElement(lhs, count: rhs).product()
}
func ** (lhs: Int, rhs: Double) -> Int {
    assert(-(1 << 53 - 1) <= lhs && lhs <= (1 << 53 - 1), "精度不足")
    let result = Int(pow(Double(lhs), rhs))
    assert(-(1 << 53 - 1) <= result && result <= (1 << 53 - 1), "精度不足")
    return result
}
func ** (lhs: Double, rhs: Double) -> Double { pow(lhs, rhs) }

extension FixedWidthInteger {
    var last: Self { self - 1 }
    var range: Range<Self> { 0 ..< self }
    var closedRange: ClosedRange<Self> { 0 ... self }
    @discardableResult func rep<T>(_ f: () throws -> T) rethrows -> [T] { try (0..<self).map{ _ in try f() } }
    @discardableResult func rep<T>(_ f: (Self) throws -> T) rethrows -> [T] { try (0..<self).map{ i in try f(i) } }
    @discardableResult func rep<T>(_ f: (Self) throws -> [T]) rethrows -> [T] { try (0..<self).flatMap{ i in try f(i) } }
}

// MARK: - Bit Convinience

extension FixedWidthInteger {
    subscript(position: Int) -> Bool {
        get { self & (1 << position) != 0 }
        mutating set {
            if newValue {
                self = self | ( 1 << position)
            } else {
                self = self & ~(1 << position)
            }
        }
    }
}


// MARK: - Output Convinience

extension Sequence where Element: CustomStringConvertible {
    func output() {
        print(map(\.description).joined(separator: " "))
    }
}

extension Collection where Element == Array<CChar> {
    func print() { forEach { Swift.print(String(cString: $0 + [0])) } }
}


// MARK: - Array Init

extension Array {
    static func * (lhs: Self, rhs: Int) -> Self {
        repeatElement(lhs, count: rhs).flatMap{ $0 }
    }
    static func * (lhs: Self, rhs: (A:Int, B:Int)) -> [Self] {
        [lhs * rhs.B] * rhs.A
    }
    static func * (lhs: Self, rhs: (A:Int, B:Int, C:Int)) -> [[Self]] {
        [[lhs * rhs.C] * rhs.B] * rhs.A
    }
    static func * (lhs: Self, rhs: (A:Int, B:Int, C:Int, D:Int)) -> [[[Self]]] {
        [[[lhs * rhs.D] * rhs.C] * rhs.B] * rhs.A
    }
}

extension String {
    
    static func * (lhs: Self, rhs: Int) -> Self {
        repeatElement(lhs, count: rhs).joined()
    }
    static func * (lhs: Self, rhs: (A:Int, B:Int)) -> [Self] {
        [lhs * rhs.B] * rhs.A
    }
}

// MARK: - Array Convinience

extension Array {
    // .suffix(...)が遅いため
    @inlinable
    public func _suffix(_ maxLength: Int) -> SubSequence {
        let amount = Swift.max(0, count - maxLength)
        let start = index(startIndex, offsetBy: amount, limitedBy: endIndex) ?? endIndex
        return self[start..<endIndex]
    }
}

extension Array where Element == Bool {
    var all: Bool { reduce(true) { $0 && $1 } }
    var any: Bool { contains(true) }
}

extension Sequence {
    func count(where f: (Element) -> Bool) -> Int {
        reduce(0) { $0 + (f($1) ? 1 : 0) }
    }
    func count(_ element: Element) -> Int where Element: Equatable {
        reduce(0) { $0 + ($1 == element ? 1 : 0) }
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
    func acc() -> [Element] { reduce(into: [.zero]) { $0.append( ($0.last ?? .zero) + $1 ) } }
}

extension Sequence where Element: BinaryInteger {
    func product() -> Element { reduce(1, *) }
    func or() -> Element { reduce(0, |) }
    func xor() -> Element { reduce(0, ^) }
}

extension Sequence where Element: BinaryFloatingPoint {
    func product() -> Element { reduce(1, *) }
}

public extension Sequence
where Element: Sequence, Element.Element: AdditiveArithmetic {
    func acc() -> [[Element.Element]] {
        let tail = map{ $0.reductions(.zero,+) }.reductions{ zip($0,$1).map(+) }
        let head = [.zero] * tail.first!.count as [Element.Element]
        return [head] + tail
    }
}

extension Collection where Element: AdditiveArithmetic {
    
    func intervals() -> [Element] {
        (0..<(distance(from: startIndex, to: endIndex) - 1)).map {
            self[index(startIndex, offsetBy: $0 + 1)] - self[index(startIndex, offsetBy: $0)]
        }
    }
}

func product(origin o: (Int,Int), size s: (Int,Int)) -> Product2Sequence<Range<Int>,Range<Int>> {
    product(o.0..<(o.0 + s.0), o.1..<(o.1 + s.1))
}

func product(origin o: SIMD2<Int>, size s: SIMD2<Int>) -> Product2Sequence<Range<Int>,Range<Int>> {
    product(o.x..<(o.x + s.x), o.y..<(o.y + s.y))
}

extension Collection where Index == Int, Element: AdditiveArithmetic & Comparable {
    
    // Maximum Subarray Problem
    // kadanes algorithm
    func maxSubarraySum() -> Element {
        var maxSum = self[0]
        var currentSum = self[0]
        for num in self[1...] {
            currentSum = Swift.max(num, currentSum + num)
            maxSum = Swift.max(maxSum, currentSum)
        }
        return maxSum
    }
}


extension Collection where Element: Equatable {
    func isSubSequence(of other: Self) -> Bool {
        var pos = other.startIndex
        for s in self {
            guard let p = other[pos..<other.endIndex].firstIndex(of: s) else {
                return false
            }
            pos = other.index(after: p)
        }
        return true
    }
}

extension SIMDMask {
    var all: Bool {
        for i in 0 ..< scalarCount {
            if !self[i] {
                return false
            }
        }
        return true
    }
    var any: Bool {
        for i in 0 ..< scalarCount {
            if self[i] {
                return true
            }
        }
        return false
    }
}
import Foundation

struct SIMD3<Scalar: SIMDScalar> {
    init(x: Scalar, y: Scalar, z: Scalar) {
        self.x = x
        self.y = y
        self.z = z
    }
    init(_ x: Scalar,_ y: Scalar,_ z: Scalar) {
        self.x = x
        self.y = y
        self.z = z
    }
    var x: Scalar
    var y: Scalar
    var z: Scalar
}
extension SIMD3: Codable where Scalar: SIMDScalar { }
extension SIMD3: SIMDStorage where Scalar: SIMDScalar & AdditiveArithmetic {
    init() { x = .zero; y = .zero; z = .zero }
}
extension SIMD3: SIMD where Scalar: SIMDScalar & AdditiveArithmetic {
    typealias MaskStorage = SIMD3<Scalar.SIMDMaskScalar>
    subscript(index: Int) -> Scalar {
        get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default: fatalError()
            }
        }
        set(newValue) {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: fatalError()
            }
        }
    }
    var scalarCount: Int { 3 }
}
extension SIMD3: Equatable where Scalar: Equatable { }
extension SIMD3: Hashable where Scalar: Hashable { }
extension SIMD3: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Scalar...) {
        (x,y,z) = (elements[0], elements[1], elements[2])
    }
}
extension SIMD3: CustomStringConvertible {
    var description: String { [x,y,z].description }
}

extension SIMD3 where Scalar: FixedWidthInteger {
    func sum() -> Scalar { x + y + z }
}
func dot<Scalar>(_ lhs: SIMD3<Scalar>,_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    (lhs &* rhs).sum()
}
func dot<Scalar>(_ lhs: SIMD3<Scalar>,_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FloatingPoint {
    (lhs * rhs).sum()
}
func length_squared<Scalar>(_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    dot(rhs, rhs)
}
func length_squared<Scalar>(_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FloatingPoint {
    dot(rhs, rhs)
}
func distance_squared<Scalar>(_ lhs: SIMD3<Scalar>,_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FixedWidthInteger {
    length_squared(lhs &- rhs)
}
func distance_squared<Scalar>(_ lhs: SIMD3<Scalar>,_ rhs: SIMD3<Scalar>) -> Scalar where Scalar: FloatingPoint {
    length_squared(lhs - rhs)
}


func min<T: Comparable>(_ a: SIMD3<T>,_ b: SIMD3<T>) -> SIMD3<T> {
    .init(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z))
}

func max<T: Comparable>(_ a: SIMD3<T>,_ b: SIMD3<T>) -> SIMD3<T> {
    .init(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z))
}

typealias VInt3 = SIMD3<Int>
