//
//  ContentView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/08.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel
    @State private var isShowingAlertRequestSent = false
    
    init(walletManager: WalletManager) {
        let viewModel = ContentViewModel(walletManager: walletManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func showAlertRequestSent() {
        isShowingAlertRequestSent = true
    }
    
    private func copyParingUri() {
        print("copyParingUri")
        do {
            if let uri = try viewModel.walletManager.generateParingUri() {
                print("uri: \(uri)")
                UIPasteboard.general.string = uri
            }
        } catch {
            print("generateParingUri error: \(error)")
        }
    }
    
    private func sendRequestPersonalSign() {
        viewModel.walletManager.sendRequestPersonalSign()
    }
    
    private func sendRequestTransferEth() {
        viewModel.walletManager.sendRequestTransferEth()
    }
    
    private func sendRequestTransferLinkToken() {
        viewModel.transferChainLink()
    }
    
    private func disconnectWallet() {
        viewModel.walletManager.disconnect()
    }
    
    var body: some View {
        VStack {
            if viewModel.walletManager.session == nil {
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
