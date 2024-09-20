import Foundation

@usableFromInline
protocol EraseProtocol: StorageProtocol & EndProtocol {
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
    let __np = __get_np(__p)
    let __r = __remove_node_pointer(__np)
    destroy(__p)
    return __r
  }

  @inlinable
  mutating func
    __erase_unique(_ __k: Element) -> Bool
  {
    let __i = find(__k)
    if __i == end() {
      return false
    }
    _ = erase(__i)
    return true
  }
}
