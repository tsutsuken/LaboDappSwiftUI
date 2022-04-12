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
    
    private func onAppear() {
        self.paringUri = createParingUri()
    }
    
    private func createParingUri() -> String {
        var paringUri = ""
        do {
            if let uri = try container.walletManager.generateParingUri() {
                print("paring uri: \(uri)")
                paringUri = uri
            }
        } catch {
            print("generateParingUri error: \(error)")
        }
        return paringUri
    }

    private func copyParingUri() {
        print("copy paring uri: \(paringUri)")
        UIPasteboard.general.string = paringUri
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
                } else {
                    Text("Wallet connected!")
                }
            }
            .navigationTitle("Connect Wallet")
        }
        .onAppear(perform: {
            onAppear()
        })
    }
}
