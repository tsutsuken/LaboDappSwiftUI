//
//  ContentView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/08.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var walletManager: WalletManager
    
    init(walletManager: WalletManager) {
        _walletManager = StateObject(wrappedValue: walletManager)
    }
    
    var body: some View {
        TabView() {
            RequestsView(walletManager: walletManager)
                .tabItem {
                    VStack {
                        Image(systemName: "paperplane.fill")
                        Text("Requests")
                    }
                }
        }
        
    }
}
