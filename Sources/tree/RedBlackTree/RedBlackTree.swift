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

