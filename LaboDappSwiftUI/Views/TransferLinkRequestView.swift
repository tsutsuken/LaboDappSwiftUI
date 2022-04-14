//
//  TransferLinkRequestView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/13.
//

import SwiftUI

struct TransferLinkRequestView: View {
    @Environment(\.container) var container: Container
    @State private var sendToAddress: String = ""
    @State private var amount: UInt = 0
    @State private var isShowingAlertRequestSent = false
    
    private func transferLink(toAddress: String, amount: UInt) {
        container.repositories.chainLinkRepository.transfer(toAddress: toAddress, amount: amount)
    }
    
    private func showAlertRequestSent() {
        isShowingAlertRequestSent = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Send to")
                        .padding(.leading, 24)
                    TextField("0x42b6fC88867383dDd507b40CD6E0DDe32C05891a", text: $sendToAddress)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.alphabet)
                        .padding()
                }
                HStack {
                    Text("Amount")
                        .padding(.leading, 24)
                    TextField("Amount", value: $amount, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .padding()
                }
                Button("Send request", action: {
                    transferLink(toAddress: sendToAddress, amount: amount)
                    showAlertRequestSent()
                })
                    .buttonStyle(.bordered)
                Spacer()
            }
            .navigationTitle("Transfer Link")
            .alert(isPresented: $isShowingAlertRequestSent) {
                Alert(title: Text("Request sent"),
                      message: Text("Confirm request on connected wallet")
                )
            }
        }
    }
}

struct TransferLinkRequestView_Previews: PreviewProvider {
    static var previews: some View {
        TransferLinkRequestView()
    }
}
