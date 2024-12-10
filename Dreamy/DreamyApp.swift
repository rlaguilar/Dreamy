//
//  DreamyApp.swift
//  Dreamy
//
//  Created by Reynaldo Aguilar on 5/12/2024.
//

import SwiftUI

@main
struct DreamyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PromptsStore())
        }
    }
}
