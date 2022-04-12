//
//  ConnectWalletView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/12.
//

import SwiftUI

struct ConnectWalletView: View {
    @Environment(\.container) var container: Container
    
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
                } else {
                    Text("Wallet connected!")
                }
            }
            .navigationTitle("Connect Wallet")
        }
    }
}
