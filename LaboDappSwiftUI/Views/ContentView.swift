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
    @State private var isShowingAlertRequestSent = false
    
    private func showAlertRequestSent() {
        isShowingAlertRequestSent = true
    }
    
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
    
    private func sendRequestPersonalSign() {
        walletManager.sendRequestPersonalSign()
    }
    
    private func sendRequestTransferEth() {
        walletManager.sendRequestTransferEth()
    }
    
    private func sendRequestTransferLinkToken() {
        walletManager.sendRequestTransferLinkToken()
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
                Button("Send request personal_sign", action: {
                    sendRequestPersonalSign()
                    showAlertRequestSent()
                })
                    .padding()
                Button("Send request transfer_eth", action: {
                    sendRequestTransferEth()
                    showAlertRequestSent()
                })
                    .padding()
                Button("Send request transfer_link", action: {
                    sendRequestTransferLinkToken()
                    showAlertRequestSent()
                })
                    .padding()
                Button("Disconnect wallet", action: {
                    disconnectWallet()
                })
                    .padding()
            }
        }
        .alert(isPresented: $isShowingAlertRequestSent) {
            Alert(title: Text("Request sent"),
                  message: Text("Confirm request on connected wallet")
            )
        }
    }
}
