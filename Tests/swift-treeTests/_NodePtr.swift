import Foundation
@testable import tree

extension _NodePtr {
    
    var offset: Int! {
        switch self {
        case .end:
            return nil
        case .nullptr:
            return nil
        default:
            return self
        }
    }
}

extension _NodePtr {
    var index: Int! { self }
}

extension _NodePtr: @retroactive ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .nullptr
    }
}
