//
//  RequestsView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct RequestsView: View {
    @StateObject private var viewModel: RequestsViewModel
    @State private var isShowingAlertRequestSent = false
    
    init(walletManager: WalletManager) {
        let viewModel = RequestsViewModel(walletManager: walletManager)
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
    
    private func personalSign() {
        viewModel.walletManager.personalSign()
    }
    
    private func transferEth() {
        viewModel.walletManager.transferEth()
    }
    
    private func transferLink() {
        viewModel.transferLink()
    }
    
    private func disconnectWallet() {
        viewModel.walletManager.disconnect()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.walletManager.session == nil {
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
