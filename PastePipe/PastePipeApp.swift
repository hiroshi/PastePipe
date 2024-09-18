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
                pasteboardObserver.startMonitoring { newText in
//                    clipboardText = newText
                }
            }
            .background(WindowAccessor { window in
                window.isOpaque = false
                window.alphaValue = 0
            })
        }
        MenuBarExtra("menu", systemImage: "doc.on.clipboard") {
            if let sourceURL = pasteboardObserver.sourceURL {
                Button(action: {
                    let pb = NSPasteboard.general
                    let value = pb.string(forType: .string)
                    pb.clearContents()
                    pb.setString("from \(sourceURL)\n\(value ?? "")", forType: .string)
                }, label: {
                    Text("Prepend SourceURL")
                })
            }
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

                    }) {
                        Text(String(data: data, encoding: .utf8) ?? "")
                    }
                }
            }
            Divider()
            Button(action: {
                NSApplication.shared.terminate(nil)
            }, label: {
                Text("quit")
            })

        }
//        .menuTitle("app")
    }
}

struct WindowAccessor: View {
    var windowConfigurator: (NSWindow) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .background(
                    WindowReader { window in
                        self.windowConfigurator(window)
                    }
                )
        }
    }
}

struct WindowReader: NSViewRepresentable {
    var callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                self.callback(window)
            }
        }
        return nsView
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
