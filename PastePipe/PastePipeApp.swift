import SwiftUI
import WasmKit
import WasmKitWASI
import JavaScriptCore

@main
struct PastePipeApp: App {
//    @State private var clipboardText: String = ""
    @StateObject private var pasteboardObserver = PasteboardObserver()

    init() {
        print("app init")
        let context = JSContext()!
//        let value = context.evaluateScript("1 + 2")
//        print(value!)
        let path = Bundle.main.path(forResource: "asc", ofType: "js")!
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            var value = context.evaluateScript(String(data: data, encoding: .utf8))
            print(value!)
            print(context.exception!)
            value = context.evaluateScript("await asc.main([])")
            print(value!)
            print(context.exception!)
        } catch {
            print("Error: \(error)")
        }
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
            Button("js core", action: {
                let context = JSContext()!
                let value = context.evaluateScript("1 + 2")
                print(value!)
//                print(value!.toString()!)
            })
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
                            do {
                                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                                let module = try parseWasm(bytes: [UInt8](data))
                                let wasi = try WASIBridgeToHost()
                                let runtime = Runtime(hostModules: wasi.hostModules)
                                let instance = try runtime.instantiate(module: module)
                                let exitCode = try wasi.start(instance, runtime: runtime)

                            } catch {
                                print("Error: \(error)")
                            }
                        } else {
                            print("hello.wasm not found.")
                        }
                    }) {
                        Text(String(data: data, encoding: .utf8) ?? "")
                    }
                    

                }
//                Button(action: {
//                    print("type: \(type) data: \(String(describing: data))")
//                }) {
//                    HStack {
//                        Text(type.rawValue)
//                        //                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
//                        Text("(\(String(describing: data.count)) bytes)")
//                            .multilineTextAlignment(.trailing)
//                        //                            .frame(maxWidth: .infinity, alignment: .trailing) // 右寄せ
//                            .frame(width: 200, alignment: .leading) // ボタンの幅を指定
//                    }
//                    .padding(.horizontal)
//                    .frame(width: 800) // 必要に応じてボタンの幅を設定 }
//                }
            }
        }
    }
}
