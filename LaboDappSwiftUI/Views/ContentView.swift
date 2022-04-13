//
//  ContentView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/08.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var walletManager: WalletManager = WalletManager()
    
    var body: some View {
        TabView() {
            RequestsView()
                .tabItem {
                    VStack {
                        Image(systemName: "paperplane.fill")
                        Text("Requests")
                    }
                }
            WalletView()
                .tabItem {
                    VStack {
                        Image(systemName: "square.fill")
                        Text("Wallet")
                    }
                }
        }
        .environment(\.container, Container.make(walletManager: walletManager))
        .sheet(isPresented: $walletManager.shouldDisplayResponseView, onDismiss: {}, content: {
            WalletResponseView()
        })
    }
}
