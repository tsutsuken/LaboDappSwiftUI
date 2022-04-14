//
//  TransferLinkRequestView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/13.
//

import SwiftUI

struct TransferLinkRequestView: View {
    @Environment(\.container) var container: Container
    @State private var amount: UInt = 0
    @State private var isShowingAlertRequestSent = false
    
    private func transferLink(amount: UInt) {
        container.repositories.chainLinkRepository.transfer(amount: amount)
    }
    
    private func showAlertRequestSent() {
        isShowingAlertRequestSent = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Amount")
                        .padding(.leading, 24)
                    TextField("Amount", value: $amount, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .padding()
                }
                Button("Send request", action: {
                    transferLink(amount: amount)
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
