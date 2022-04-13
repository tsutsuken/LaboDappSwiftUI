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
    @State private var isPresentedCopyDoneAlert = false
    
    private func presentSheetConnectWallet() {
        isPresentedSheetConnectWallet = true
    }
    
    private func presentCopyDoneAlert() {
        isPresentedCopyDoneAlert = true
    }
    
    private func copyAddress() {
        let address = container.walletManager.address()
        UIPasteboard.general.string = address
    }
    
    private func openEtherscan() {
        guard let address = container.walletManager.address() else {
            return
        }
        
        let urlEtherscanRinkeby = "https://rinkeby.etherscan.io/address/\(address)"
        guard let url = URL(string: urlEtherscanRinkeby) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func disconnectWallet() {
        container.walletManager.disconnect()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if container.walletManager.session == nil {
                    Button("Connect wallet", action: {
                        presentSheetConnectWallet()
                    })
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 24)
                } else {
                    List {
                        Section(content: {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy address")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                copyAddress()
                                presentCopyDoneAlert()
                            }
                            .alert("Copied address", isPresented: $isPresentedCopyDoneAlert, actions: {})
                            HStack {
                                Image(systemName: "eye.fill")
                                Text("View on Etherscan")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                openEtherscan()
                            }
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                Text("Logout")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                disconnectWallet()
                            }
                        }, header: {
                            Text("\(container.walletManager.address() ?? "No Address")")
                                .font(.headline)
                                .lineLimit(1)
                                .truncationMode(.middle)
                                .padding()

                        })
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
