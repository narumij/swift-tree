import Foundation

@usableFromInline
protocol EraseProtocol: StorageProtocol & EndProtocol {
  func find(_ __v: _Key) -> _NodePtr
  mutating func __remove_node_pointer(_ __ptr: _NodePtr) -> _NodePtr
}

extension EraseProtocol {

  @inlinable
  func __get_np(_ p: _NodePtr) -> _NodePtr { p }

  @inlinable
  mutating func
    erase(_ __p: _NodePtr) -> _NodePtr
  {
    let __np = __get_np(__p)
    let __r = __remove_node_pointer(__np)
    destroy(__p)
    return __r
  }

  @inlinable
  mutating func
    __erase_unique(_ __k: _Key) -> Bool
  {
    let __i = find(__k)
    if __i == end() {
      return false
    }
    _ = erase(__i)
    return true
  }
  
//  template <class _Tp, class _Compare, class _Allocator>
//  template <class _Key>
//  typename __tree<_Tp, _Compare, _Allocator>::size_type
//  __tree<_Tp, _Compare, _Allocator>::__erase_multi(const _Key& __k) {
//    pair<iterator, iterator> __p = __equal_range_multi(__k);
//    size_type __r                = 0;
//    for (; __p.first != __p.second; ++__r)
//      __p.first = erase(__p.first);
//    return __r;
//  }
  @inlinable
  mutating func __erase_multi(_ __k: _Key) {
    
  }
}
