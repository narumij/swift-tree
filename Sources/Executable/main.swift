import Foundation
import swift_tree

var tree = RedBlackTreeContainer<Int>()
tree.reserveCapacity(1_000_000)
for i in 0 ..< 1_000_000 {
    _ = tree.__insert_unique(i)
}
print("Hola!")

