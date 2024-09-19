import Foundation

protocol EraseProtocol
: RemoveProtocol
& StorageProtocol
& NodeFindProtocol { }

extension EraseProtocol {
    
    @inlinable
    func __get_np(_ p: _NodePtr) -> _NodePtr { p }
    
    @inlinable
    func
    erase(_ __p: _NodePtr) -> _NodePtr
    {
        let __np    = __get_np(__p)
        let __r     = __remove_node_pointer(__np)
        destroy(__p)
        return __r
    }
    
    @inlinable
    func
    __erase_unique(_ __k: Element) -> Int {
        let __i = find(__k)
        if (__i == end()) {
            return 0 }
        _ = erase(__i)
        return 1
    }
}

