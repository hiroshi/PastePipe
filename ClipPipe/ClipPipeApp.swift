//
//  ClipPipeApp.swift
//  ClipPipe
//
//  Created by hiroshi on 2024/07/28.
//

import SwiftUI

@main
struct ClipPipeApp: App {
    // AppDelegateインスタンスを作成
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
//            ContentView()
            EmptyView()
        }
    }
}
