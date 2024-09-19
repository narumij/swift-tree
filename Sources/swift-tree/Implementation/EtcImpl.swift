import Foundation

@usableFromInline
protocol RefImpl: MemberSetProtocol { }

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
protocol RootImpl: MemberProtocol & EndImpl { }

extension RootImpl {
    @inlinable
    @inline(__always)
    func __root() -> _NodePtr { __left_(__end_node()) }
}

@usableFromInline
protocol RootPtrImpl: RefProtocol & EndImpl { }

extension RootPtrImpl {
    @inlinable
    func __root_ptr() -> _NodeRef { __left_ref(__end_node()) }
}

@usableFromInline
protocol EndImpl { }

extension EndImpl {
    
    @inlinable
    @inline(__always)
    func __end_node() -> _NodePtr { .end }
    
    @inlinable
    @inline(__always)
    func end() -> _NodePtr { .end }
}
