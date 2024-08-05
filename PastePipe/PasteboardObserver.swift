import AppKit

class PasteboardObserver: ObservableObject {
    @Published var clipboardText: String = ""
    private var lastChangeCount: Int = 0
    private var timer: Timer?

    func startMonitoring(onChange: @escaping (String) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let pasteboard = NSPasteboard.general
            if pasteboard.changeCount != self.lastChangeCount {
                self.lastChangeCount = pasteboard.changeCount
                if let newText = pasteboard.string(forType: .string) {
                    DispatchQueue.main.async {
                         self.clipboardText = newText
                     }
                    onChange(newText)
                    print("Clipboard updated: \(newText)")
                }
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}
