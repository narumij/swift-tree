import Foundation

#if false
extension BasePtr2 {
    
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

extension BasePtr2 {
    var index: Int! { self }
}
#endif
