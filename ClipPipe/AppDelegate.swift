import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // ステータスアイテムを作成
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star", accessibilityDescription: "Status Item")
            button.action = #selector(statusItemClicked)
        }
    }

    @objc func statusItemClicked() {
        let alert = NSAlert()
        alert.messageText = "ステータスアイテムがクリックされました。"
        alert.runModal()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // クリーンアップ処理
    }
}
