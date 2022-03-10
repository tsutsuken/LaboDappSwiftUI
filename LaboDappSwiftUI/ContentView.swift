//
//  ContentView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/08.
//

import SwiftUI
import WalletConnect
import WalletConnectUtils

struct ContentView: View {
    @EnvironmentObject var walletManager: WalletManager
    
    private func copyParingUri() {
        print("copyParingUri")
        do {
            if let uri = try walletManager.generateParingUri() {
                print("uri: \(uri)")
                UIPasteboard.general.string = uri
            }
        } catch {
            print("generateParingUri error: \(error)")
        }
    }
    
    private func sendRequest() {
        walletManager.sendRequest()
    }
    
    private func disconnectWallet() {
        walletManager.disconnect()
    }
    
    var body: some View {
        VStack {
            if walletManager.session == nil {
                Button("Copy paring uri", action: {
                    copyParingUri()
                })
                    .padding()
            } else {
                Button("Send request", action: {
                    sendRequest()
                })
                    .padding()
                Button("Disconnect wallet", action: {
                    disconnectWallet()
                })
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
