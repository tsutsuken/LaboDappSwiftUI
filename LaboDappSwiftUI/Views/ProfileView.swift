//
//  ProfileView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct ProfileView: View {
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
    
    private func disconnectWallet() {
        container.walletManager.disconnect()
    }
    
    var body: some View {
        NavigationView {
            List {
                if container.walletManager.session == nil {
                    HStack {
                        Text("Copy paring uri")
                            .onTapGesture {
                                copyParingUri()
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
            .navigationTitle("Profile")
        }
    }
}
