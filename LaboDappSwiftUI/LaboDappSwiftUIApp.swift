//
//  LaboDappSwiftUIApp.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/08.
//

import SwiftUI
import WalletConnect

@main
struct LaboDappSwiftUIApp: App {
    @StateObject private var walletManager = WalletManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(walletManager)
        }
    }
}
 
