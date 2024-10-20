import Foundation

public enum RedBlackTree {}

extension RedBlackTree {

  public struct Iterator<Iteratee: RedBlackTreeIteratee>: IteratorProtocol {
    @inlinable
    init(container: Iteratee, ptr: _NodePtr) {
      self.container = container
      self.ptr = ptr
    }
    @usableFromInline
    let container: Iteratee
    @usableFromInline
    var ptr: _NodePtr
    @inlinable
    public mutating func next() -> Iteratee.Element? {
      defer { if ptr != .end { ptr = container.iteratorNext(ptr: ptr) } }
      return ptr == .end ? nil : container.iteratorValue(ptr: ptr)
    }
  }
}

public
  protocol RedBlackTreeIteratee
{
  associatedtype Element
  func iteratorNext(ptr: _NodePtr) -> _NodePtr
  func iteratorValue(ptr: _NodePtr) -> Element
}

extension RedBlackTreeSetContainer {

  public func iteratorNext(ptr: _NodePtr) -> _NodePtr {
    _read { $0.__tree_next_iter(ptr) }
  }

  public func iteratorValue(ptr: _NodePtr) -> Element {
    values[ptr]
  }
}
