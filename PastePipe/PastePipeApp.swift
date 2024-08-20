import SwiftUI

@main
struct PastePipeApp: App {
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
        MenuBarExtra("menu", systemImage: "doc.on.clipboard") {
            Text(pasteboardObserver.clipboardText)
            Divider()
            ForEach(pasteboardObserver.types, id:\.self) {type in
                let data = NSPasteboard.general.data(forType: type)!
                //                Menu(type.rawValue) {
                //                    Text(String(describing: data))
                //                }
                Menu("\(type.rawValue) (\(String(describing: data.count)) bytes)") {
                    //                    print("type: \(type) data: \(String(describing: data))")
                    //                    Button (action:{
                    //
                    //                    }, label: {
                    //                        String(data: data, encoding: .utf8)
                    //                    })
                    Button(action: {
                        if let path = Bundle.main.path(forResource: "hello", ofType: "wasm") {
                            print("path: \(path)")
                        } else {
                            print("hello.wasm not found.")
                        }
                    }) {
                        Text(String(data: data, encoding: .utf8) ?? "")
                    }
                }
            }
        }
    }
}
