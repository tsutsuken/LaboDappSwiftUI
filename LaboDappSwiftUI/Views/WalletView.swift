//
//  WalletView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct WalletView: View {
    @Environment(\.container) var container: Container
    @State var isPresentedSheetConnectWallet = false
    
    private func presentSheetConnectWallet() {
        isPresentedSheetConnectWallet = true
    }
    
    private func disconnectWallet() {
        container.walletManager.disconnect()
    }
    
    var body: some View {
        NavigationView {
            List {
                if container.walletManager.session == nil {
                    HStack {
                        Text("Connect wallet")
                            .onTapGesture {
                                presentSheetConnectWallet()
                            }
                    }
                } else {
                    Section {
                        HStack {
                            Text("Address")
                                .bold()
                            Text("\(container.walletManager.address() ?? "No Address")")
                        }
                    }
                    Section {
                        HStack {
                            Text("Disconnect wallet")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    disconnectWallet()
                                }
                        }
                    }
                }
            }
            .navigationTitle("Wallet")
            .sheet(isPresented: $isPresentedSheetConnectWallet, onDismiss: {}, content: {
                ConnectWalletView()
            })
        }
    }
}
