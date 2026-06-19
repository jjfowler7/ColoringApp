import SwiftUI

extension View {
    /// Conditionally applies a transformation to the view.
    /// Usage: .if(isIPad) { $0.padding(.horizontal, 48) }
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
