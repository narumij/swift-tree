import Foundation
@testable import swift_tree

#if true
extension _NodeRef {
    var index: Int! {
        switch self {
        case .__right_(let p):
            return p
        case .__left_(let p):
            return p
        default:
            return nil
        }
    }
}
#endif
