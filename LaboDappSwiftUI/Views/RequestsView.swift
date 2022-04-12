//
//  RequestsView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct RequestsView: View {
    @Environment(\.container) var container: Container
    @State private var isShowingAlertRequestSent = false
    
    private func showAlertRequestSent() {
        isShowingAlertRequestSent = true
    }
    
    private func copyParingUri() {
        print("copyParingUri")
        do {
            if let uri = try container.walletManager.generateParingUri() {
                print("uri: \(uri)")
                UIPasteboard.general.string = uri
            }
        } catch {
            print("generateParingUri error: \(error)")
        }
    }
    
    private func personalSign() {
        container.walletManager.personalSign()
    }
    
    private func transferEth() {
        container.walletManager.transferEth()
    }
    
    private func transferLink() {
        container.repositories.chainLinkRepository.transfer(amount: 1)
    }
    
    private func disconnectWallet() {
        container.walletManager.disconnect()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if container.walletManager.session == nil {
                    List {
                        HStack {
                            Text("Copy paring uri")
                                .onTapGesture {
                                    copyParingUri()
                                }
                        }
                    }
                    .navigationTitle("Connect To Wallet")
                } else {
                    List {
                        HStack {
                            Text("Personal sign")
                                .onTapGesture {
                                    personalSign()
                                    showAlertRequestSent()
                                }
                        }
                        HStack {
                            Text("Transfer Eth")
                                .onTapGesture {
                                    transferEth()
                                    showAlertRequestSent()
                                }
                        }
                        HStack {
                            Text("Transfer Link")
                                .onTapGesture {
                                    transferLink()
                                    showAlertRequestSent()
                                }
                        }
                        HStack {
                            Text("Disconnect wallet")
                                .onTapGesture {
                                    disconnectWallet()
                                }
                        }
                    }
                    .navigationTitle("Requests")
                    .alert(isPresented: $isShowingAlertRequestSent) {
                        Alert(title: Text("Request sent"),
                              message: Text("Confirm request on connected wallet")
                        )
                    }
                }
            }
        }
    }
}
