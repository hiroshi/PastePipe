import AppKit

class PasteboardObserver: ObservableObject {
    @Published var clipboardText: String = ""
    @Published var sourceURL: String? = nil
    @Published var types: [NSPasteboard.PasteboardType] = []
    private var lastChangeCount: Int = 0
    private var timer: Timer?

    func startMonitoring(onChange: @escaping (String) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            let pasteboard = NSPasteboard.general
            if pasteboard.changeCount != self.lastChangeCount {
                self.lastChangeCount = pasteboard.changeCount
                self.types = pasteboard.types ?? []
                print("Pastebaord changed")
                for type in self.types {
                    print("type: \(type.rawValue)")
                }
                if let newText = pasteboard.string(forType: .string) {
                    DispatchQueue.main.async {
                         self.clipboardText = newText
                     }
                    onChange(newText)
                    print("Clipboard updated: \(newText)")
                }
                self.sourceURL = pasteboard.string(forType: NSPasteboard.PasteboardType(rawValue: "org.chromium.source-url"))
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}
