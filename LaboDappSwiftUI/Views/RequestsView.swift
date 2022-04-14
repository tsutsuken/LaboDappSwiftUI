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
    
    private func personalSign() {
        container.walletManager.personalSign()
    }
    
    private func transferEth() {
        container.walletManager.transferEth()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if container.walletManager.session == nil {
                    Text("Wallet not connected")
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
                        NavigationLink(destination: TransferLinkRequestView()) {
                            HStack {
                                Text("Transfer Link")
                            }
                        }
                    }
                    .alert(isPresented: $isShowingAlertRequestSent) {
                        Alert(title: Text("Request sent"),
                              message: Text("Confirm request on connected wallet")
                        )
                    }
                }
            }
            .navigationTitle("Requests")
        }
    }
}
