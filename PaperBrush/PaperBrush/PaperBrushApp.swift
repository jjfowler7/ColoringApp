import SwiftUI

@main
struct PaperBrushApp: App {
    // AppRouter manages all navigation state (push path + modal presentations)
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}
