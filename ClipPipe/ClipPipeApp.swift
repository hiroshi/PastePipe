import SwiftUI

@main
struct ClipPipeApp: App {
//    @State private var clipboardText: String = ""
    @StateObject private var pasteboardObserver = PasteboardObserver()

    init() {
        print("app init")
    }

    var body: some Scene {
        // NOTE: onAppear() of views in MenuBarExtra never called, but a StateObject need a view to be installed.
        WindowGroup {
            EmptyView()
            .onAppear {
                if let window = NSApplication.shared.windows.first {
                    window.setIsVisible(false)
                }
                pasteboardObserver.startMonitoring { newText in
//                    clipboardText = newText
                }
            }
        }
        MenuBarExtra("menu", systemImage: "star") {
            Text(pasteboardObserver.clipboardText)
        }
    }
}
