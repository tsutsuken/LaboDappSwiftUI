//
//  ConnectWalletView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/12.
//

import SwiftUI

struct ConnectWalletView: View {
    @Environment(\.container) var container: Container
    @State private var paringUri: String = ""
    @State private var isPresentedErrorAlert = false
    @State private var isPresentedCopyDoneAlert = false
    
    private func onAppear() {
        self.paringUri = createParingUri()
    }
    
    private func createParingUri() -> String {
        var paringUri = ""
        do {
            if let uri = try container.walletManager.generateParingUri() {
                print("paring uri: \(uri)")
                paringUri = uri
            } else {
                presentErrorAlert()
            }
        } catch {
            presentErrorAlert()
            print("createParingUri error: \(error)")
        }
        return paringUri
    }

    private func copyParingUri() {
        print("copy paring uri: \(paringUri)")
        UIPasteboard.general.string = paringUri
    }
    
    private func presentCopyDoneAlert() {
        isPresentedCopyDoneAlert = true
    }
    
    private func presentErrorAlert() {
        isPresentedErrorAlert = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if container.walletManager.session == nil {
                    Text("Copy \"Pairing URI\" below, and paste it in wallet app which supports WalletConnect v2")
                        .font(.headline)
                        .padding()
                    Button(action: {
                        copyParingUri()
                        presentCopyDoneAlert()
                    }, label: {
                        HStack {
                            Text(paringUri)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Image(systemName: "doc.on.doc")
                        }
                    })
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 24)
                        .alert("Copied Paring URI", isPresented: $isPresentedCopyDoneAlert, actions: {})
                } else {
                    Text("Wallet connected!")
                }
            }
            .navigationTitle("Connect Wallet")
        }
        .onAppear(perform: {
            onAppear()
        })
        .alert("Connecting Wallet Error", isPresented: $isPresentedErrorAlert, actions: {}, message: {
            Text("Please restart the app")
        })
    }
}
